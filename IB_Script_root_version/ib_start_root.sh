#!/usr/bin/ksh 
#
# Author: 
#		 Bruce Hsiao
#
# Email: 
#		bruce_hsiao@win-way.com.tw
#
# Platform OS: 
#			  AIX 7.1
#
# Program:
#   1. Collocation the Power HA. This program to detection "Infinband card" and Infiniband network status. 
#	2. Run this script, first you need to install the Power HA filesets.
#	3. Second you need to setting the rbac config it, for privilege to twse user.
#   4. If the local IB card port 1 failed, than switch card 1 port 2. 
#      If the local IB card are all failed, use ssh to check the hostB Infinbad card status.
#      If hostB IB card status has active status,than use Power HA clRGmove command to move RG from hostA to hostsB, and hostB initial IB card.
#	5. Detection the ib network status,if has the packet loss the record it to the log.
#   6. If ib network packet loss 100% 2 times, than switch another ib card.
#	   If second ib card both loss 100% , than switch to hostB. use Power HA clRGmove command to move RG from hostA to hostsB. 
#
# History:
# 2014/04/22 Bruce release
# 2014/04/23 Bruce release
# 2014/04/25 Bruce release
# 2014/04/27 Bruce release
# 2014/04/29 Bruce release
# 2014/05/02 Bruce release
# 2014/05/03 Bruce release
# 2014/05/03 Bruce release
# 2014/05/12 Bruce release
# 2014/05/13 Bruce release
# 2014/05/14 Bruce release
# 2014/06/07 Bruce release
# 2014/06/21 Bruce release
# 2014/07/24 Bruce release
#
# version:
# 1.0 release
# 1.1 release, The ping function add new parameter -I for confirm source ip to destination ip path.
# 1.2 release, The check_ib_hwstatus function change.
# 1.3 release, The ping_check functin to fix the loop status
# 1.4 release, The loss_100_ib_hwstatus functin to change swap IB sequence.
# 1.5 release, The ping_check add new flag name swflag,for swap the IB count numbers.
# 1.6 release, Fix the ping_check function bug.
# 1.7 release, Fix the check_ib_hwstatus's local_check function bug, reduce the ibstat command execute, the command execute very slow.
# 1.8 release, new the user_check function and add new parameter for check type1 or type2 and the ip are different.
# 1.9 release, reduce the ibstat command execute, ib card status sotre in the variable. 
# 2.0 release, Use IB_STATUS parameter to store ibstate command execute status.
# 2.1 release, Use ifconifg command to check the base Ib card Status,it can be faster than ibstat to check the ib card hardware status.
# 2.2 release, Use slow command ibstat to check the ib card hardware status.
# 2.3 release, delete CMDCYCLE parameter for command.
# 2.4 release, add aptlog function for ap program format.
# 
# set -x 

SITE="TSEOA1"
HADIR="/usr/es/sbin/cluster/utilities"
IBMON="/TWSE/bin"
RG_NAME_LIST=$( ${HADIR}/clRGinfo | grep RG | awk '{print $1}' 2>/dev/null )
RG_NAME=$(echo $RG_NAME_LIST | sed 's/ /,/g')
TYPE1A="FIXGW01P"
TYPE1B="FIXGW01B"
TYPE2A="FIXGW02P"
TYPE2B="FIXGW02B"
IB_STATUS=""
IBA0=$(lsdev | grep iba[0-9] | head -1 | awk '{print $1}')
IBA1=$(lsdev | grep iba[0-9] | tail -1 | awk '{print $1}')
USER=$(whoami)
INTERVAL="3"
COUNT="5"
HACYCLE="2"
NOW_HOST=$(hostname)
PORT="2222"
OLDIFS=$IFS
LOGDIR="/TWSE/IB_log"
LOG=${LOGDIR}/ib_start_stop.sh.log
APLOGDIR="/TWSE/IB_log"
APLOG="${APLOGDIR}/aplog.txt"
PGNAME=IB_MON
haflag="0"
swflag="0"
iba0p1="0"
iba0p2="0"
iba1p1="0"
iba1p2="0"
TARGETIP="10.204.5.71  10.204.5.81  10.204.5.71"
today=$(date +"%Y%m%d")
set -A 	DESIPR $TARGETIP
DESIP_NUM=${#DESIPR[@]}

#{{{tlog ,script loger function
tlog() {

    MSG=$1
    LOG=$2
	dt=$(date +"%Y/%m/%d %H:%M:%S")
	today=$(date +"%Y%m%d")

	echo "$SITE [${dt}] $MSG" | tee  -a ${LOG}.${today}

	exec_status=$?
	if [[ $exec_status -ne "0" ]]; then
		echo "Please to check the LOG:${LOG}.${today}"
		return 1
	else 
		return 0
	fi
}
#}}}

#{{{aptlog ,aptlog function
aptlog() {

	TYP=$1
    MSG=$2
	LOGAP=$3

	DAY=$(date +"%Y%m%d")
	TIME=$(date +"%H:%M:%S")

	echo "CODE:${TYP} $PGNAME $DAY $TIME $MSG" | tee  -a $LOGAP
	exec_status=$?
	if [[ $exec_status -ne "0" ]]; then
		echo "Please to check the LOG:${LOGAP}"
		return 1
	else 
		return 0
	fi
}

#}}}

if [[ $NOW_HOST = $TYPE1A ]] || [[ $NOW_HOST = $TYPE1B ]];then
	HOSTA=$TYPE1A
	HOSTB=$TYPE1B
	HSOTA_VL4="10.199.168.143"
	HSOTB_VL4="10.199.168.145"
	IPADDR="10.204.5.141"
# Example type and ip
elif [[ $NOW_HOST = $TYPE2A ]] || [[ $NOW_HOST = $TYPE2B ]];then
	HOSTA=$TYPE2A
	HOSTB=$TYPE2B
	HSOTA_VL4="10.199.168.144"
	HSOTB_VL4="10.199.168.146"
	IPADDR="10.204.5.142"
else
	tlog "The Host type are wrong type" ${LOG}.${today}
	exit 1
fi

set -A MUSER twse root

#-----------------------------------------------------------------------------#


#{{{errlogger to aix errpt log 
erlogger() {

    MSG=$1
	#use Rbac function.
	swrole exec.errlogger "-c errlogger $MSG"
}
#}}}

#{{{user_check
user_check (){
# check user information.  
	userflag=0
	for chkuser in ${MUSER[@]}
	do
		if [[ $USER = $chkuser ]];then
			userflag=1
			return 0
		fi
	done

	if [[ $userflag -eq "0" ]];then 
		return 1
	fi
}
#}}}

#{{{moniter ib script exec status
ib_moniter (){
		IFS=$OLDIFS
		#ibsmon client to reset clock
		#	                        Notify_file    millis count
		${IBMON}/ibsmon_np_client  /tmp/ib_moni      0      0   >> ${LOG}.${today} 2>&1
		exec_status=$?
		if [[ $exec_status -ne "0" ]]; then
			tlog "[ERR] ibsmon_np may be has problem,Please to check it" $LOG
#			aptlog "E" "ibsmon_np服務有問題"  $APLOG
			return 1
		else 
			return 0
	    fi
}
#}}}

#{{{ibsmon_np stop it
ibsmon_np() {
#set -x 
#tlog "#==========================ib_script_stop...================================================#" $LOG

SHNAME="ibsmon_np"
	tlog "[INFO] Terminated ibsmon_np  start" $LOG
	
	PIDNUM=$(ps -ef | grep $SHNAME | grep -v grep | awk '{print $2}')

	if [[ ! -n $PIDNUM ]];then
		tlog "[INFO] The ibsmon_np PID already is empty" $LOG
		return 0
	fi
	# kill the ib_start.sh process
	# if have 2 the same process,loop to kill the process
	for PID in $PIDNUM
	do
		kill -9 $PID
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] To terminate ibsmon_np:$PID Success" $LOG
		else 
			tlog "[INFO] To terminate ibsmon_np failed ,Please to check the process" $LOG
			return 1
		fi
	done

	return 0
}
#}}}

#{{{step:1 , main
main () {
#tlog "#==========================main function...==========================================#" $LOG
today=$(date +"%Y%m%d")

	while  true
	do
		echo "\n" | tee -a ${LOG}.${today}
		tlog "***************************InfiniBand monitor begins**********************************" $LOG
		tlog "[INFO] Primary host is $NOW_HOST, Alternative host $HOSTB" $LOG

		#ibsmon client to reset clock
		ib_moniter

		#check exec user is twse
		user_check
		exec_status=$?
		if [[ $exec_status -eq "0"  ]];then	
			check_ib_ip_status
		else
			print "[ERR] $USER permission denied, than $0 script terminated  " ${LOG}.${today}
#			aptlog "E" "目前使用者為${USER},應為twse"  $APLOG
			ibsmon_np	
			exit 1
		fi

		tlog "[INFO] Sleep for ${INTERVAL} seconds..." $LOG
		sleep ${INTERVAL}
	done
}
#}}}

#{{{step:2 , check_ib_ip_status
check_ib_ip_status () {
#set -x 
#tlog "#==========================check_ib_ip_status function...============================#" $LOG
	#check the ib card does have bind the ip
	ifconfig -a | grep ${IPADDR}[[:space:]] >/dev/null 2>>${LOG}.${today}

	#if exec_status = 0 , than check ib hwstatus else no ip setting than execute the ib_ip_config to set ip address on ib card
	exec_status=$?
	if [[ $exec_status -eq "0" ]];then
		tlog "[INFO] Execute check_ib_hwstatus function Start" $LOG
		check_ib_hwstatus
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] check_ib_hwstatus function Success" $LOG
		else 
			tlog "[ERR] check_ib_hwstatus function Failed" $LOG
#			aptlog "E" "執行check_ib_hwstatus失敗,程式終止"  $APLOG
			ibsmon_np
			exit 1
		fi
	else
		tlog "[INFO] Need to Bind the ip:${IPADDR} on Infiniband card" $LOG
		# ib_ip_config function to set ip address on ib card
		tlog "[INFO] Execute ib_ip_config function Start" $LOG
		ib_ip_conifg	
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			erlogger "[INFO] Bind the ip:${IPADDR} on ib Finished"
			tlog "[INFO] Bind the ip:${IPADDR} on ib Finished" $LOG
			# re-execute the check_ib_ip_status function
			check_ib_ip_status
		else 
			erlogger "[ERR] Bind the ip:${IPADDR} on ib Failed, and $0 script terminated"
			tlog "[ERR] Bind the ip:${IPADDR} on ib Failed,and $0 script terminated" $LOG
#			aptlog "E" "設定IB網路IP:${IPADDR}失敗,程式終止"  $APLOG
			ibsmon_np	
			exit 1
		fi
#		tlog "[INFO] Execute ib_ip_config function Finished" $LOG
	fi
}
#}}}

#{{{step:3 , ib_ip_conifg 
ib_ip_conifg () {
#set -x 
#tlog "#==========================ib_ip_conifg...===========================================#" $LOG
		# search the first Active ib card and port
		set -A DEV_IB_PORT_LIST $(ibstat | grep Active | head -1 | awk '{print $2,$3}' | tr -d '()' )
		if [[ ${#DEV_IB_PORT_LIST} -eq "1" ]];then
			DEV_IB_PORT=${DEV_IB_PORT_LIST[0]}
			DEV_IB=${DEV_IB_PORT_LIST[1]}
		else
			tlog "[ERR] Local check all failed, begins to check alternate server connection..." $LOG
#			aptlog "E" "本機IB網卡全失敗,檢查遠端主機"  $APLOG
			if [[ $NOW_HOST = $HOSTA ]];then
				ssh_check
				exec_status=$?
				if [[ $exec_status -eq "0" ]];then
					remote_check
				else
					tlog "[ERR] ssh_check function check sshd $HOSTB service has question and $0 script terminated" $LOG
#					aptlog "E" "SSH服務連線至備援機失敗,程式終止"  $APLOG
					return 1
				fi
			else
				tlog "[ERR] $NOW_HOST is Backup lpar, then don't move Resource Group and $0 script terminated " $LOG
#				aptlog "E" "本機為備援主機,不進行RG切換"  $APLOG
				return 1
			fi
		fi

		tlog "[INFO] Bind ip on ib0 device from device Card:(${DEV_IB}) Port:(${DEV_IB_PORT})" $LOG

		# use rbac function,set ip address on ib card
#swrole exec.chdev "-c chdev -l ib0 -a ib_adapter=${DEV_IB} -a ib_port=${DEV_IB_PORT} -a state=up -a netaddr=${IPADDR} -a netmask=255.255.255.0 > /dev/null 2>>${LOG}.${today}"
		chdev -l ib0 -a ib_adapter=${DEV_IB} -a ib_port=${DEV_IB_PORT} -a state=up -a netaddr=${IPADDR} -a netmask=255.255.255.0 > /dev/null 2>>${LOG}.${today}
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			return 0
		else 
			return $exec_status
		fi
}
#}}}

#{{{step:4 , check_ib_hwstatus
check_ib_hwstatus() {
#set -x
#tlog "#==========================check_ib_hwstatus function...=============================#" $LOG

	DEV_NOW=$(lsattr -El ib0 | grep ib_adapter | awk '{print $2}')
	DEV_NOW_PORT=$(lsattr -El ib0 | grep ib_port | awk '{print $2}')

	#check ib hardware status
	local_check ${DEV_NOW} ${DEV_NOW_PORT}
	#ifconfig ib0 | grep -E '.*UP.*RUNNING' > /dev/null 2>&1
	exec_status=$?
	if [[ $exec_status -eq "0" ]]; then
		ping_check
		return 0
	else
		# Check ib hardware status
		#local_check ${DEV_NOW} ${DEV_NOW_PORT}

		# Check ib card status is active, if don't then execute remote_check function.
		DEVP_ACT_CUNT=$(echo $IB_STATUS | grep Active | wc -l | awk '{print $1}')

		if [[ $DEVP_ACT_CUNT -gt "0" ]]; then
#			Check which ib card status is failed.
			DEV_NOW=$(lsattr -El ib0 | grep ib_adapter | awk '{print $2}')
			# DEV_NOW = iba0 or iba1
			case $DEV_NOW in 
				$IBA0)
					DEV_NOW_PORT=$(echo $IB_STATUS | grep $DEV_NOW | grep Active | awk '{print $2}')
					# DEV_NOW_PORT = 1 or 2 , mean iba0 port 1 or port 2
					# exec_status=$?
					if [[ -z $DEV_NOW_PORT ]]; then
						DEV_IB=$IBA1
						# DEV_IB = iba1
						DEV_NOW_PORT=$(echo $IB_STATUS | grep $DEV_IB | grep Active |head -1 | awk '{print $2}')
						# DEV_IB_PORT = iba1 active port , maybe iba1 port 1 or port 2 
					else 
						DEV_IB=$DEV_NOW
						# DEV_IB = iba0
						DEV_IB_PORT=$DEV_NOW_PORT
						# DEV_IB_PORT = 1 or 2 , mean iba0 port 1 or port 2
					fi
					;;
				$IBA1)
					DEV_NOW_PORT=$(echo $IB_STATUS | grep $DEV_NOW | grep Active | awk '{print $2}')
					# DEV_NOW_PORT = 1 or 2 , mean iba1 port 1 or port 2
					#exec_status=$?
					#if [[ $exec_status -eq "0" ]]; then
					if [[ -z $DEV_NOW_PORT ]]; then
						DEV_IB=$IBA0
						# DEV_IB = iba0
						DEV_NOW_PORT=$(echo $IB_STATUS | grep $DEV_IB | grep Active |head -1 | awk '{print $2}')
						# DEV_IB_PORT = iba0 active port , maybe iba0 port 1 or port 2 
					else 
						DEV_IB=$DEV_NOW
						# DEV_IB = iba1
						DEV_IB_PORT=$DEV_NOW_PORT
						# DEV_IB_PORT = 1 or 2 , mean iba1 port 1 or port 2
					fi
					;;
				*)
					tlog "[ERR] IB card number has wrong message:${DEV_IB}" $LOG
#erlogger "[ERR] IB card number has wrong message:${DEV_IB}"
#					aptlog "E" "IB網卡資訊錯誤:${DEV_IB}"  $APLOG
					ibsmon_np
					exit 1
					;;
			esac
			tlog "[WARN] Local InfiniBand card check success, begins to swap Device:${DEV_IB} Port:${DEV_NOW_PORT}" $LOG
#			aptlog "W" "切換至Device:(${DEV_IB}) Port:(${DEV_NOW_PORT})"  $APLOG
			# sample: swap iba0 2
			swap ${DEV_IB} ${DEV_NOW_PORT}
			return 0
		else 
			tlog "[ERR] Local InfiniBand card check all failed, begins to check alternate server connection..." $LOG
#			aptlog "E" "本機IB網卡全失敗,檢查遠端主機"  $APLOG
			if [[ $NOW_HOST = $HOSTA ]];then
				ssh_check
				exec_status=$?
				if [[ $exec_status -eq "0" ]];then
					remote_check
				else
					tlog "[ERR] ssh_check function check sshd $HOSTB service has question" $LOG
#erlogger "[ERR] ssh_check function check sshd $HOSTB service has question"
#					aptlog "E" "SSH服務連線至備援機失敗,程式終止"  $APLOG
					ibsmon_np
					exit 1
				fi
			else
				tlog "[ERR] $NOW_HOST is Backup lpar, than don't move Resource Group and $0 script terminated " $LOG
#				aptlog "E" "$NOW_HOST 本機為備援主機,不進行RG切換,程式終止"  $APLOG
				ibsmon_np
				exit 1
			fi
		fi
	fi
}
#}}}

#{{{step:5 , local_check
local_check() {
#set -x 
#tlog "#============================local_check function...=================================#" $LOG
	IB_CARD=$1
	IB_PORT=$2
	IFS='\n'
	IB_STATUS=$(ibstat)

	#ibsmon client to reset clock
	#ib_moniter

	tlog "[INFO] Executing Local_check Start, To Check ib_card=${IB_CARD} ib_port=${IB_PORT} status" $LOG
	#ibstat "$IB_CARD" | grep "PORT $IB_PORT" | grep "Active" > /dev/null  2>>$LOG
	echo $IB_STATUS	 | grep "$IB_CARD" | grep "PORT $IB_PORT" | grep "Active" > /dev/null  2>>${LOG}.${today}
	exec_status=$?
	if [[ $exec_status -eq "0" ]];then
		tlog "[INFO] Executing Local_check finished. The ib_card=${IB_CARD} ib_port=${IB_PORT} status is Active" $LOG
		return 0
	else 
		tlog "[ERR] Executing Local_check finished. The ib_card=${IB_CARD} ib_port=${IB_PORT} status not Active" $LOG
#		aptlog "E" "IBCARD:${IB_CARD} IBPORT:${IB_PORT} 失敗"  $APLOG
		return $exec_status
	fi
}
#}}}

#{{{setp:6 , ping_check
ping_check() {
#set -x 
#tlog "#==========================ping_check function...====================================#" $LOG

		DEV_NOW=$(lsattr -El ib0 | grep ib_adapter | awk '{print $2}')
		DEV_NOW_PORT=$(lsattr -El ib0 | grep ib_port | awk '{print $2}')
		tlog "[INFO] Now IB device Card:(${DEV_NOW}) Port:(${DEV_NOW_PORT})" $LOG

		dipflag="0"
		# DESIP_NUM = TARGETIP = "10.204.5.71  10.204.5.72  10.204.5.71  10.204.5.72" = 4
		while [ $dipflag -lt $DESIP_NUM ]  
		do
			LOSS=$(ping -q -c $COUNT -w 1 -I $IPADDR ${DESIPR[$dipflag]} | grep loss | cut -d '%' -f 1 | awk '{print $NF}')

				# if ib ping network destination is wrong , than terminate the script
				if [[ -z $LOSS ]];then
					tlog "[ERR] Network address local ip:${IPADDR} destination:${DESIPR[$dipflag]} has problem, to check the InfiniBand Network status " $LOG	
#					aptlog "E" "檢查${DESIPR[$dipflag]}網路結果失敗"  $APLOG
					# check the ib ip status
					check_ib_ip_status
				fi

				# if ping ib ip loss 100% ,than ping next ip address, until the ip address arrary finishd, if all 100% loss than swap ib card
				if [[ $LOSS -eq "100" ]];then
					tlog "[ERR] InfiniBand Network ping to ${DESIPR[$dipflag]} ${LOSS}% packet loss" $LOG	
#erlogger "[ERR] InfiniBand Network ping to ${DESIPR[$dipflag]} ${LOSS}% packet loss"
#					aptlog "E" "PING IP:${DESIPR[$dipflag]} 封包LOSS ${LOSS}%"  $APLOG

					dipflag=$(($dipflag+1))
					swflag=$dipflag
					# DESIP_NUM = TARGETIP = "10.204.5.71  10.204.5.73  10.204.5.71" = 3
					if [[ $swflag -eq $DESIP_NUM ]];then
						# if 2 ib card loss are 100% , than RG move to the HOSTB
						# HACYCLE = 2
						haflag=$(($haflag+1))
						if [[ $haflag -eq $HACYCLE ]];then
							if [[ $NOW_HOST = $HOSTA ]];then
									ssh_check
									exec_status=$?
									if [[ $exec_status -eq "0" ]];then
										remote_check
									else
										tlog "[ERR] ssh_check function check sshd $HOSTB service has question" $LOG
#erlogger "[ERR] ssh_check function check sshd $HOSTB service has question"
#										aptlog "E" "SSH服務連線至備援機失敗,程式終止"  $APLOG
										ibsmon_np
										exit 1
									fi
							else
								tlog "[ERR] $NOW_HOST is Backup lpar, then don't move Resource Group and $0 script terminated " $LOG
#erlogger "[ERR] $NOW_HOST is Backup lpar, then don't move Resource Group and $0 script terminated "
#								aptlog "E" "${NOW_HOST}為備援主機,不進行RG切換,程式終止"  $APLOG
								ibsmon_np
								exit 1
							fi
						fi
						loss_100_ib_hwstatus
						exec_status=$?
						if [[ $exec_status -eq "0" ]];then

							swflag=0
							dipflag=0
						else
							if [[ $NOW_HOST = $HOSTA ]];then
									ssh_check
									exec_status=$?
									if [[ $exec_status -eq "0" ]];then
										remote_check
									else
										tlog "[ERR] ssh_check function check sshd $HOSTB service has question" $LOG
#erlogger "[ERR] ssh_check function check sshd $HOSTB service has question"
										aptlog "E" "SSH服務連線至備援機失敗,程式終止"  $APLOG
										ibsmon_np
										exit 1
									fi
							else
								tlog "[ERR] $NOW_HOST is Backup lpar, then don't move Resource Group and $0 script terminated " $LOG
#erlogger "[ERR] $NOW_HOST is Backup lpar, then don't move Resource Group and $0 script terminated "
								aptlog "E" "${NOW_HOST}為備援主機,不進行RG切換,程式終止"  $APLOG
								ibsmon_np
								exit 1
							fi
						fi
					fi
					continue
				fi

				if [[ $LOSS -eq "0" ]];then
					tlog "[INFO] InfiniBand Network ping to ${DESIPR[$dipflag]} status is OK" $LOG	
					if [[ $NOW_HOST = $HOSTA ]];then
						ssh_check
					fi
					dipflag=0
					haflag=0
					swflag=0
					iba0p1=0
					iba0p2=0
					iba1p1=0
					iba1p2=0
					return 0
				else
					tlog "[WARN] InfiniBand Network ping to ${DESIPR[$dipflag]} ${LOSS}% packet loss" $LOG	
#erlogger "[WARN] InfiniBand Network ping to ${DESIPR[$dipflag]} ${LOSS}% packet loss"

					if [[ $LOSS -ge "25" ]] && [[ $LOSS -lt "50" ]] ;then
						aptlog "W" "PING IP:${DESIPR[$dipflag]} 封包LOSS ${LOSS}%"  $APLOG
					fi
					if [[ $LOSS -ge "50" ]] ;then
						aptlog "E" "PING IP:${DESIPR[$dipflag]} 封包LOSS ${LOSS}%"  $APLOG
					fi
					dipflag=0
					haflag=0
					swflag=0
					iba0p1=0
					iba0p2=0
					iba1p1=0
					iba1p2=0
					return 0
				fi
		done

}
#}}}

#{{{setp:7 , loss_100_ib_hwstatus
loss_100_ib_hwstatus() {
#set -x 
#tlog "#==========================loss_100_ib_hwstatus function...==========================#" $LOG

	DEV_NOW=$(lsattr -El ib0 | grep ib_adapter | awk '{print $2}')
	DEV_NOW_PORT=$(lsattr -El ib0 | grep ib_port | awk '{print $2}')

	#check ib hardware status
	local_check ${DEV_NOW} ${DEV_NOW_PORT}

	tlog "[INFO] Now IB device Card:(${DEV_NOW}) Port:(${DEV_NOW_PORT})" $LOG

	#DEVP_ACT_CUNT=$(ibstat | grep Active | wc -l| awk '{print $1}')
	DEVP_ACT_CUNT=$(echo $IB_STATUS | grep Active | wc -l | awk '{print $1}')

	#if [[ $DEVL_ACT_CUNT -gt "0" ]] && [[ $DEVP_ACT_CUNT -gt "0" ]]; then
	if [[ $DEVP_ACT_CUNT -gt "0" ]]; then
		IBA0P1_S=$(echo $IB_STATUS | grep $IBA0 | grep Active | grep "PORT 1" | wc -l |awk '{print $1}')
		IBA0P2_S=$(echo $IB_STATUS | grep $IBA0 | grep Active | grep "PORT 2" | wc -l |awk '{print $1}')
		IBA1P1_S=$(echo $IB_STATUS | grep $IBA1 | grep Active | grep "PORT 1" | wc -l |awk '{print $1}')
		IBA1P2_S=$(echo $IB_STATUS | grep $IBA1 | grep Active | grep "PORT 2" | wc -l |awk '{print $1}')


		#ibsmon client to reset clock
		#IFS=$OLDIFS
		ib_moniter

		DEV_PORT="${DEV_NOW},${DEV_NOW_PORT}"
		case $DEV_PORT in 
			${IBA0},1)
				iba0p1=1
				# iba1 , port 2
				if [[ $IBA1P2_S -eq "1" ]] && [[ $iba1p2 -eq "0" ]];then
					DEV_IB=$IBA1
					DEV_IB_PORT="2"
				fi
				# iba1 , port 1
				if [[ $IBA1P1_S -eq "1" ]] && [[ $iba1p1 -eq "0" ]];then
					DEV_IB=$IBA1
					DEV_IB_PORT="1"
				fi
				# iba0 , port 2
				if [[ $IBA0P2_S -eq "1" ]] && [[ $iba0p2 -eq "0" ]];then
					DEV_IB=$IBA0
					DEV_IB_PORT="2"
				fi
				;;
			${IBA0},2)
				iba0p2=1
				# iba1 , port 2
				if [[ $IBA1P2_S -eq "1" ]] && [[ $iba1p2 -eq "0" ]];then
					DEV_IB=$IBA1
					DEV_IB_PORT="2"
				fi
				# iba1 , port 1
				if [[ $IBA1P1_S -eq "1" ]] && [[ $iba1p1 -eq "0" ]];then
					DEV_IB=$IBA1
					DEV_IB_PORT="1"
				fi
				# iba0 , port 1
				if [[ $IBA0P1_S -eq "1" ]] && [[ $iba0p1 -eq "0" ]];then
					DEV_IB=$IBA0
					DEV_IB_PORT="1"
				fi
				;;
			${IBA1},1)
				iba1p1=1
				# iba0 , port 2
				if [[ $IBA0P2_S -eq "1" ]] && [[ $iba0p2 -eq "0" ]];then
					DEV_IB=$IBA0
					DEV_IB_PORT="2"
				fi
				# iba0 , port 1
				if [[ $IBA0P1_S -eq "1" ]] && [[ $iba0p1 -eq "0" ]];then
					DEV_IB=$IBA0
					DEV_IB_PORT="1"
				fi
				# iba1 , port 2
				if [[ $IBA1P2_S -eq "1" ]] && [[ $iba1p2 -eq "0" ]];then
					DEV_IB=$IBA1
					DEV_IB_PORT="2"
				fi
				;;
			${IBA1},2)
				iba1p2=1
				# iba0 , port 2
				if [[ $IBA0P2_S -eq "1" ]] && [[ $iba0p2 -eq "0" ]];then
					DEV_IB=$IBA0
					DEV_IB_PORT="2"
				fi
				# iba0 , port 1
				if [[ $IBA0P1_S -eq "1" ]] && [[ $iba0p1 -eq "0" ]];then
					DEV_IB=$IBA0
					DEV_IB_PORT="1"
				fi
				# iba1 , port 1
				if [[ $IBA1P1_S -eq "1" ]] && [[ $iba1p1 -eq "0" ]];then
					DEV_IB=$IBA1
					DEV_IB_PORT="1"
				fi
				;;
				 *)
				tlog "[ERR] IB card number has wrong message:${DEV_IB} ${DEV_IB_PORT}" $LOG
				aptlog "E" "IB網卡資訊錯誤:${DEV_IB} PORT:${DEV_IB_PORT}"  $APLOG
				ibsmon_np
				exit 1
			;;
		esac

		if [[ $iba0p1 -ne "0" ]] && [[ $iba0p2 -ne "0" ]] && [[ $iba1p1 -ne "0" ]] && [[ $iba1p2 -ne "0" ]] ;then
			tlog "[ERR] ALL IB device used" $LOG
			return	1
		fi

		tlog "[WARN] Local InfiniBand card check success, begins to swap Device:${DEV_IB} Port:${DEV_IB_PORT}" $LOG
		aptlog "W" "切換至Device:(${DEV_IB}) Port:(${DEV_NOW_PORT})"  $APLOG
		swap ${DEV_IB} ${DEV_IB_PORT}
#		ping_check
		return 0
	else
		tlog "[ERR] Local InfiniBand card check all failed, begins to check alternate server connection..." $LOG
#erlogger "[ERR] Local InfiniBand card check all failed, begins to check alternate server connection..." 
		aptlog "E" "本機IB網卡全失敗,檢查遠端主機"  $APLOG
			if [[ $NOW_HOST = $HOSTA ]];then
				ssh_check
				exec_status=$?
				if [[ $exec_status -eq "0" ]];then
					remote_check
				else
					tlog "[ERR] ssh_check function check sshd $HOSTB service has question" $LOG
					aptlog "E" "SSH服務連線至備援機失敗,程式終止"  $APLOG
					ibsmon_np
					exit 1
				fi
			else
				tlog "[ERR] $NOW_HOST is Backup lpar, then don't move Resource Group and $0 script terminated " $LOG
#erlogger "[ERR] $NOW_HOST is Backup lpar, then don't move Resource Group and $0 script terminated "
				aptlog "E" "${NOW_HOST}為備援主機,不進行RG切換,程式終止"  $APLOG
				ibsmon_np
				exit 1
			fi
	fi
}
#}}}

#{{{setp:8 , ssh_service check 
ssh_check() {
#set -x 
#tlog "#===========================ssh_check function....===================================#" $LOG
		ssh -p ${PORT} -o BatchMode=yes ${HSOTB_VL4} "hostname > /dev/null 2>&1"
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] SSHD service check finished" $LOG
			return 0
		else
			tlog "[ERR] ${HSOTB_VL4} sshd service has question,Please to check the ${HSOTB_VL4} ssh service or ssh-key change question " $LOG
#erlogger "[ERR] ${HSOTB_VL4} sshd service has question,Please to check the ${HSOTB_VL4} ssh service or ssh-key change question "
			aptlog "E" "SSH服務失敗,請確認主備機援SSH連線"  $APLOG
			return $exec_status
		fi
}
#}}}

#{{{setp:9 , swap
swap() {
#set -x 
#tlog "#==========================swap function...==========================================#" $LOG

	NEW_IB=$1
	NEW_IB_PORT=$2
	tlog "[INFO] Detach ib0 device..." $LOG
#erlogger "[INFO] Detach ib0 device..."

		# detach the ib0 
		# Use Rbac function, detach ib0
#swrole exec.chdev "-c chdev -l ib0 -a state=detach > /dev/null 2>>${LOG}.${today}"
		chdev -l ib0 -a state=detach > /dev/null 2>>${LOG}.${today}
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Detach ib0 success " $LOG
			break
		else 
			tlog "[ERR] Detach ib0 Failed,than $0 script terminated"  $LOG
#erlogger "[ERR] Detach ib0 Failed,than $0 script terminated" 
			aptlog "E" "停止IB網卡失敗,程式終止"  $APLOG
			ibsmon_np
			exit 1 
		fi



		# Use new iba card to bind ip on ib0 
		# Use Rbac function, bind ip on ib card
#swrole exec.chdev "-c chdev -l ib0 -a ib_adapter=${NEW_IB} -a ib_port=${NEW_IB_PORT} -a state=up -a netaddr=${IPADDR} -a netmask=255.255.255.0 > /dev/null 2>>${LOG}.${today}"
		chdev -l ib0 -a ib_adapter=${NEW_IB} -a ib_port=${NEW_IB_PORT} -a state=up -a netaddr=${IPADDR} -a netmask=255.255.255.0 > /dev/null 2>>${LOG}.${today}
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Bind ip:${IPADDR} on ib0 success " $LOG
			tlog "[INFO] Swap finished, ib0 network work on IB device Card:(${NEW_IB}) Port:(${NEW_IB_PORT}) " $LOG
#			erlogger "[INFO] Swap finished, ib0 network work on IB device Card:\(${NEW_IB}\) Port:\(${NEW_IB_PORT}\)"
#			ping_check
			return 0
		else 
			tlog "[ERR] Bind ip:${IPADDR} on ib0 Failed,than $0 script terminated"  $LOG
#erlogger "[ERR] Bind ip:${IPADDR} on ib0 Failed,than $0 script terminated" 
			aptlog "E" "設定IB網卡IP:${IPADDR}失敗,程式終止"  $APLOG
			ibsmon_np
			exit 1 
		fi
}
#}}}

#{{{setp:10 , remote_check
remote_check() {
#set -x 
#tlog "#==========================remote_check function..===================================#" $LOG
	ALT_DEV=$(ssh -p ${PORT} ${HOSTB} ibstat | grep Active | head -1 | awk '{print $3}' | tr -d "()" )
	if [[ ${ALT_DEV} = iba[0-9] ]]; then
		tlog "[ERR] ${HOSTB} ${ALT_DEV} alive, begins to transfer IP $IPADDR from $NOW_HOST to $HOSTB ..." $LOG
		aptlog "E" "將${IPADDR}由${NOW_HOST}切換至${HOSTB}"  $APLOG
			# detach the ib0 
			#  Use Rbac function , detach ib0
#swrole exec.chdev "-c chdev -l ib0 -a state=detach > /dev/null 2>>${LOG}.${today}"
			chdev -l ib0 -a state=detach > /dev/null 2>>${LOG}.${today}
			exec_status=$?
			if [[ $exec_status -eq "0" ]];then
				tlog "[INFO] Detach ib0 success, begins to transfer HACMP" $LOG
				break
			else 
				tlog "[ERR] Detach ib0 Failed,than $0 script terminated"  $LOG
#				erlogger "[ERR] Detach ib0 Failed,than $0 script terminated" 
#				aptlog "E" "停止IB網卡失敗,程式終止"  $APLOG
				ibsmon_np
				exit 1 
			fi

		#use Rbac function, rg move to hostb
#swrole exec.clRGmove "-c ${HADIR}/clRGmove -s 'false'  -m -i -g ${RG_NAME} -n ${HOSTB} > /dev/null 2>>${LOG}.${today}"
		${HADIR}/clRGmove -s 'false'  -m -i -g ${RG_NAME} -n ${HOSTB} > /dev/null 2>>${LOG}.${today}
		exec_status=$?
		if [[ $exec_status -eq 0 ]]; then
			tlog "[INFO] HACMP transfer completed, script terminated..." $LOG
#erlogger "[INFO] HACMP transfer completed, script terminated..."
			exit 0
		else
			tlog "[ERR] HACMP transfer failed, please check HACMP status by cldump, script terminated..." $LOG
#erlogger "[ERR] HACMP transfer failed, please check HACMP status by cldump, script terminated..."
			aptlog "E" "切換HACMP失敗,程式終止"  $APLOG
			exit 1
		fi
	else
		tlog "[ERR] We are not going to move ; $NOW_HOST and $HOSTB physical connections all fail, script terminate" $LOG
		aptlog "E" "主備援機IB網卡全失敗,程式終止"  $APLOG
		ibsmon_np
		exit 0
	fi
}
#}}}

main
