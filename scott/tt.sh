#!/bin/sh 

INTERVAL="5"
IPADDR="192.168.100.50"
PINGADDR=""
HOSTA="OAT2_C1"
HOSTB="OAT2_C2"
RG_NAME="OAT2_1_RG"

NOW_HOST=`hostname`
LOGFILE=/tmp/scott/tt.output

if [ ${NOW_HOST} == ${HOSTA} ]; then
	ALT_HOST=${HOSTB}
else
	ALT_HOST=${HOSTA}
fi

to_log() {
	echo "`date \"+%b-%m %H:%M:%S\"` : $1 " >> $LOGFILE
}

local_check() {
	to_log "[INFO] Executing Local check"
	ibstat $1 | grep Active > /dev/null 2>&1
}

remote_check() {
	ALT_DEV=`ssh -p 2222 ${ALT_HOST} ibstat |grep Active |head -1 | awk '{print $3}' | tr -d "()"`
	if [[ ${ALT_DEV} == iba[0-9] ]]; then
		to_log "[WARN] ${ALT_HOST} ${ALT_DEV} alive, begins to transfer IP $IPADDR from $NOW_HOST to $ALT_HOST ..."
		ifconfig ib0 detach
		ssh -p 2222 ${ALT_HOST} mkiba -a ${IPADDR} -i ib0 -A ${ALT_DEV} -p 1 -P 0xFFFF -S up -m 255.255.255.0 -M 2044 > /dev/null 2>&1
		to_log "[INFO] Assigned IP ${IPADDR} on ${ALT_HOST} done, begins to transfer HACMP"
		/usr/es/sbin/cluster/utilities/clRGmove -s 'false'  -m -i -g ${RG_NAME} -n ${ALT_HOST} >> /dev/null 2>&1
		HA_RESULT=$?
		if [ $? -eq 0 ]; then
			to_log "[INFO] HACMP transfer completed, script terminated..."
		else
			to_log "[ERROR] HACMP transfer failed, please check HACMP status by cldump, script terminated..."
		fi
		exit 0
	else
		to_log "[ERROR] We are not going to move ; $NOW_HOST and $ALT_HOST physical connections all fail, script terminate"
		exit 0
	fi
}

ping_check() {
	LOSS=`ping -q -c 4 ${PINGADDR} | grep loss | awk '{print $7}' | cut -d% -c1`
}

swap() {
	if [ $1 == "iba0" ]; then
		to_log "[INFO] Detaching ib0 device from $1..."
		ifconfig ib0 detach
		mkiba -a ${IPADDR} -i ib0 -A iba1 -p 1 -P 0xFFFF -S up -m 255.255.255.0 -M 2044 > /dev/null 2>&1
		to_log "[INFO] Done, ib0 working on iba1"
	else
		to_log "[INFO] Detaching ib0 device from $1..."
		ifconfig ib0 detach
		mkiba -a ${IPADDR} -i ib0 -A iba0 -p 1 -P 0xFFFF -S up -m 255.255.255.0 -M 2044 > /dev/null 2>&1
		to_log "[INFO] Done, ib0 working on iba0"
	fi
}

check_status() {
	DEV_NOW=`lsattr -El ib0 |grep adapter | awk '{print $2}'`
	local_check ${DEV_NOW}; IF=$?

	if [ ${IF} -eq 0 ]; then
		to_log "[INFO] ${IPADDR} on ${DEV_NOW} check ok, sleep for ${INTERVAL} seconds..."
		sleep ${INTERVAL}
		check_status
	else
		if [ `ibstat | grep Active | wc -l` -gt 0 ]; then
			to_log "[WARN] Local check failed, begins to swap device ${DEV_NOW}"
			swap ${DEV_NOW} 
		else 
			to_log "[WARN] Local check all failed, begins to check alternate server connection..."
			remote_check
		fi

		sleep ${INTERVAL}
		check_status
	fi
}

#main
while(true)
do
	echo "\n\n\n" >> $LOGFILE
	to_log "**************InfiniBand monitor begins*****************"
	to_log "[INFO] Primary host is $NOW_HOST, Alternative host $ALT_HOST"
	check_status
done

