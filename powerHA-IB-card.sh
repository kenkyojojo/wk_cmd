#!/bin/sh -x

HOSTNAME=`hostname`
INTERVAL="5"
IPADDR="192.168.100.50"


local_check() {
	ibstat $1 | grep scott > /dev/null 2>&1
}

swap() {
	if [ $1 == "ib0" ]; then
		#echo "ifconfig $1 detach ; mktcpip -h ${HOSTNAME} -a ${IPADDR} -m 255.255.255.0 -i ib1"
		mkiba -a ${IPADDR} -i $1 -A iba0 -p 1 -P 0xFFFF -S up -m 255.255.255.0 -M 2044
	else
		#echo "ifconfig $1 detach ; mktcpip -h ${HOSTNAME} -a ${IPADDR} -m 255.255.255.0 -i ib0"
		mkiba -a ${IPADDR} -i $1 -A iba1 -p 1 -P 0xFFFF -S up -m 255.255.255.0 -M 2044
	fi
}

check_status() {
	IF_NOW=`netstat -in |grep ${IPADDR}| awk '{print $1}'`
	DEV_NOW=`echo $IF_NOW | sed 's/^\(.\{2\}\)/\1a/'`
	local_check ${DEV_NOW}; IF=$?
	echo ${IF}

	if [ ${IF} -eq 0 ]; then
		echo "1st sec."
		sleep ${INTERVAL}
		check_status
	else [ ${IF} -ne 0 ]
		echo "2nd sec."
		swap ${IF_NOW} 
		sleep ${INTERVAL}
		check_status
	fi
}

#main
while(true)
do
	check_status
done

