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
# 
#set -x 

SITE="TSEOT2"
HADIR="/usr/es/sbin/cluster/utilities"
RG_NAME_LIST=$( ${HADIR}/clRGinfo | grep RG | awk '{print $1}' 2>/dev/null )
RG_NAME=$(echo $RG_NAME_LIST | sed 's/ /,/g')
TYPE1A="test_ha_1"
TYPE1B="test_ha_2"
TYPE2A="test_ha2_1"
TYPE2B="test_ha2_2"
IBA0="iba0"
IBA2="iba2"
#RG_NAME="RG1"
USER=$(whoami)
INTERVAL="3"
COUNT="4"
FAILCYCLE="2"
CMDCYCLE="2"
HACYCLE="6"
NOW_HOST=$(hostname)
PORT="2222"
LOGDIR=/home/tse/twse/script_log
LOG=${LOGDIR}/ib_start_stop.sh.log
IBA="iba"
haflag="0"
swflag="0"
iba0p1="0"
iba0p2="0"
iba2p1="0"
iba2p2="0"

#{{{tlog ,script loger function
tlog() {

    MSG=$1
    LOG=$2
	dt=$(date +"%Y/%m/%d %H:%M:%S")
	dt2=$(date +"%Y/%m/%d")

	echo "$SITE [${dt}] $MSG" | tee  -a ${LOG}.${dt2}
}
#}}}

if [[ $NOW_HOST = $TYPE1A || $NOW_HOST = $TYPE1B ]];then
	HOSTA=$TYPE1A
	HOSTB=$TYPE1B
	HSOTA_VL4="10.199.170.101"
	HSOTB_VL4="10.199.170.102"
	IPADDR="192.168.1.1"
	DESIPR="192.168.1.200"
# Example type and ip
elif [[ $NOW_HOST = $TYPE2A || $NOW_HOST = $TYPE2B ]];then
	HOSTA=$TYPE2A
	HOSTB=$TYPE2B
	HSOTA_VL4="10.199.170.103"
	HSOTB_VL4="10.199.170.104"
	IPADDR="192.168.1.2"
	DESIPR="192.168.1.202"
else
	tlog "The Host type are wrong type" $LOG
	exit 1
fi

set -A MUSER twse

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

#{{{step:1 , main
main () {
#tlog "#==========================main function...==========================================#" $LOG

	while  true
	do
		print "\n" | tee -a $LOG
		tlog "***************************InfiniBand monitor begins**********************************" $LOG
		tlog "[INFO] Primary host is $NOW_HOST, Alternative host $HOSTB" $LOG

		#check exec user is twse
		user_check
		exec_status=$?
		if [[ $exec_status -eq "0"  ]];then	
			check_ib_ip_status
		else
			print "[ERR] $USER permission denied, than $0 script terminated  " $LOG
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
	ifconfig -a | grep ${IPADDR}[[:space:]] >/dev/null 2>>$LOG

	#if exec_status = 0 , than check ib hwstatus else no ip setting than execute the ib_ip_config to set ip address on ib card
	exec_status=$?
	if [[ $exec_status -eq "0" ]];then
		tlog "[INFO] Execute check_ib_hwstatus function Start" $LOG
		check_ib_hwstatus
#		ping_check
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] check_ib_hwstatus function Success" $LOG
		else 
			tlog "[ERR] check_ib_hwstatus function Failed" $LOG
		fi
		tlog "[INFO] Execute check_ib_hwstatus function Finished" $LOG
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
			exit 1
		fi
		tlog "[INFO] Execute ib_ip_config function Finished" $LOG
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
			tlog "[WARN] Local check all failed, begins to check alternate server connection..." $LOG
			if [[ $NOW_HOST = $HOSTA ]];then
				ssh_check
				exec_status=$?
				if [[ $exec_status -eq "0" ]];then
					remote_check
				else
					tlog "[ERR] ssh_check function check sshd $HOSTB service has question and $0 script terminated" $LOG
					exit 1
				fi
			else
				tlog "[WARN] $NOW_HOST is Backup lpar, then don't move Resource Group and $0 script terminated " $LOG
				exit 1
			fi
		fi

		tlog "[INFO] Bind ip on ib0 device from device Card:(${DEV_IB}) Port:(${DEV_IB_PORT})" $LOG

		# use rbac function,set ip address on ib card
		swrole exec.chdev "-c chdev -l ib0 -a ib_adapter=${DEV_IB} -a ib_port=${DEV_IB_PORT} -a state=up -a netaddr=${IPADDR} -a netmask=255.255.255.0 > /dev/null 2>>$LOG"
#		swrole exec.mkiba,exec.chdev "-c mkiba -a ${IPADDR} -i ib0 -A ${DEV_IB} -p ${DEV_IB_PORT} -P 0xFFFF -S up -m 255.255.255.0 -M 2044 > /dev/null 2>&1"
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
	exec_status=$?
	if [[ $exec_status -eq "0" ]]; then
		ping_check
		return 0
	else
		# Check ib card status is active, if don't then execute remote_check function.
		DEVL_ACT_CUNT=$(lsdev -Cc adapter | grep "${IBA}.[[:space:]]" | grep 'Available' | wc -l | awk '{print $1}')
		DEVP_ACT_CUNT=$(ibstat | grep Active | wc -l | awk '{print $1}')

		if [[ $DEVL_ACT_CUNT -gt "0" && $DEVP_ACT_CUNT -gt "0" ]]; then
#			Check which ib card status is failed.
			DEV_NOW=$(lsattr -El ib0 | grep ib_adapter | awk '{print $2}')
			# DEV_NOW = iba0 or iba2
			case $DEV_NOW in 
				$IBA0)
					DEV_NOW_PORT=$(ibstat $DEV_NOW | grep Active | awk '{print $2}')
					# DEV_NOW_PORT = 1 or 2 , mean iba0 port 1 or port 2
					exec_status=$?
					if [[ $exec_status -eq "0" ]]; then
						DEV_IB=$DEV_NOW
						# DEV_IB = iba0
						DEV_IB_PORT=$DEV_NOW_PORT
						# DEV_IB_PORT = 1 or 2 , mean iba0 port 1 or port 2
					else 
						DEV_IB=$IBA2
						# DEV_IB = iba2
						DEV_NOW_PORT=$(ibstat $DEV_IB | grep Active | head -1 | awk '{print $2}')
						# DEV_IB_PORT = iba2 active port , maybe iba2 port 1 or port 2 
					fi
					;;
				$IBA2)
					DEV_NOW_PORT=$(ibstat $DEV_NOW | grep Active | awk '{print $2}')
					# DEV_NOW_PORT = 1 or 2 , mean iba2 port 1 or port 2
					exec_status=$?
					if [[ $exec_status -eq "0" ]]; then
						DEV_IB=$DEV_NOW
						# DEV_IB = iba2
						DEV_IB_PORT=$DEV_NOW_PORT
						# DEV_IB_PORT = 1 or 2 , mean iba2 port 1 or port 2
					else 
						DEV_IB=$IBA0
						# DEV_IB = iba0
						DEV_NOW_PORT=$(ibstat $DEV_IB | grep Active | head -1 | awk '{print $2}' )
						# DEV_IB_PORT = iba0 active port , maybe iba0 port 1 or port 2 
					fi
					;;
				*)
					tlog "[WARN] IB card number has wrong message:${DEV_IB}" $LOG
					exit 1
					;;
			esac
			tlog "[WARN] Local InfiniBand card check success, begins to swap Device:${DEV_IB} Port:${DEV_NOW_PORT}" $LOG
			# sample: swap iba0 2
			swap ${DEV_IB} ${DEV_NOW_PORT}
			return 0
		else 
			tlog "[WARN] Local InfiniBand card check all failed, begins to check alternate server connection..." $LOG
			if [[ $NOW_HOST = $HOSTA ]];then
				ssh_check
				exec_status=$?
				if [[ $exec_status -eq "0" ]];then
					remote_check
				else
					tlog "[ERR] ssh_check function check sshd $HOSTB service has question" $LOG
					exit 1
				fi
			else
				tlog "[WARN] $NOW_HOST is Backup lpar, then don't move Resource Group and $0 script terminated " $LOG
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
	tlog "[INFO] Executing Local_check Start, To Check ib_card=${IB_CARD} ib_port=${IB_PORT} status" $LOG
	ibstat "$IB_CARD" | grep "PORT $IB_PORT" | grep "Active" > /dev/null  2>>$LOG
	exec_status=$?
	if [[ $exec_status -eq "0" ]];then
		tlog "[INFO] Executing Local_check finished. The ib_card=${IB_CARD} ib_port=${IB_PORT} status is Active" $LOG
		return 0
	else 
		tlog "[INFO] Executing Local_check finished. The ib_card=${IB_CARD} ib_port=${IB_PORT} status no Active" $LOG
		return $exec_status
	fi
}
#}}}

#{{{setp:6 , ping_check
ping_check() {
#set -x 
#tlog "#==========================ping_check function...====================================#" $LOG

	if [[ ! -z $1 ]];then
		DESIP=$1
	else
		DESIP=$DESIPR
	fi

	flag=1
	# FAILCYCLE="2"
	while [ $flag -le $FAILCYCLE ]
	do
		DEV_NOW=$(lsattr -El ib0 | grep ib_adapter | awk '{print $2}')
		DEV_NOW_PORT=$(lsattr -El ib0 | grep ib_port | awk '{print $2}')
		tlog "[INFO] Now IB device Card:(${DEV_NOW}) Port:(${DEV_NOW_PORT})" $LOG

		LOSS=$(ping -q -c $COUNT -w 1 -i 1 -I $IPADDR $DESIP | grep loss | cut -d '%' -f 1 | awk '{print $NF}')
		# if ib ping network destination is wrong , than terminate the script
		if [[ -z $LOSS ]];then
			tlog "[ERR] Network address local ip:${IPADDR} destination:${DESIP} has problem, to check the InfiniBand Network status " $LOG	
			# check the ib ip status
			check_ib_ip_status
		fi

		# if ib network perfect,than skip the flowing step,and reset the haflag
		if [[ $LOSS -eq "0" ]];then
			tlog "[INFO] InfiniBand Network status is correct" $LOG	
			if [[ $NOW_HOST = $HOSTA ]];then
				ssh_check
			fi
			haflag=0
			swflag=0
			iba0p1=0
			iba0p2=0
			iba2p1=0
			iba2p2=0
			return 0
		elif [[ $LOSS -eq "100"  ]];then
			tlog "[ERR] InfiniBand Network ${LOSS}% packet loss" $LOG	
			erlogger "[ERR] InfiniBand Network ${LOSS}% packet loss"
			haflag=$(($haflag+1))
			swflag=$(($swflag+1))
			# if ping ip loss 100% 2 times , than exectue loss_100_ib_hwstatus function.
			# FAILCYCLE="2"
			if [[ $swflag -eq $FAILCYCLE ]];then
				# if 2 ib card loss are 100% , than RG move to the HOSTB
				# HACYCLE="6"
				if [[ $haflag -eq $HACYCLE ]];then
					if [[ $NOW_HOST = $HOSTA ]];then
							ssh_check
							exec_status=$?
							if [[ $exec_status -eq "0" ]];then
								remote_check
							else
								tlog "[ERR] ssh_check function check sshd $HOSTB service has question" $LOG
								erlogger "[ERR] ssh_check function check sshd $HOSTB service has question"
								exit 1
							fi
					else
						tlog "[WARN] $NOW_HOST is Backup lpar, then don't move Resource Group and $0 script terminated " $LOG
						erlogger "[WARN] $NOW_HOST is Backup lpar, then don't move Resource Group and $0 script terminated "
						exit 1
					fi
				fi
				loss_100_ib_hwstatus
				swflag=0
				flag=0
			fi
		else
			tlog "[ERR] InfiniBand Network ${LOSS}% packet loss" $LOG	
			erlogger "[ERR] InfiniBand Network ${LOSS}% packet loss"
			return 0
		fi
		flag=$(($flag+1))
	done

	return 0
}
#}}}

#{{{setp:7 , loss_100_ib_hwstatus
loss_100_ib_hwstatus() {
#set -x 
#tlog "#==========================loss_100_ib_hwstatus function...==========================#" $LOG

	DEV_NOW=$(lsattr -El ib0 | grep ib_adapter | awk '{print $2}')
	DEV_NOW_PORT=$(lsattr -El ib0 | grep ib_port | awk '{print $2}')
	tlog "[INFO] Now IB device Card:(${DEV_NOW}) Port:(${DEV_NOW_PORT})" $LOG

	DEVL_ACT_CUNT=$(lsdev -Cc adapter | grep "$IBA.[[:space:]]" | grep 'Available' | wc -l | awk '{print $1}')
	DEVP_ACT_CUNT=$(ibstat | grep Active | wc -l| awk '{print $1}')

	if [[ $DEVL_ACT_CUNT -gt "0" && $DEVP_ACT_CUNT -gt "0" ]]; then
		IBA0P1_S=$(ibstat $IBA0 | grep Active | grep "PORT 1" | wc -l |awk '{print $1}')
		IBA0P2_S=$(ibstat $IBA0 | grep Active | grep "PORT 2" | wc -l |awk '{print $1}')
		IBA2P1_S=$(ibstat $IBA2 | grep Active | grep "PORT 1" | wc -l |awk '{print $1}')
		IBA2P2_S=$(ibstat $IBA2 | grep Active | grep "PORT 2" | wc -l |awk '{print $1}')

		DEV_PORT="${DEV_NOW},${DEV_NOW_PORT}"
		case $DEV_PORT in 
			${IBA0},1)
				iba0p1=1
				DEV_IB=$IBA0
				DEV_IB_PORT="2"
				# iba2 , port 2
				if [[ $IBA2P2_S -eq "1" && $iba2p2 -eq "0" ]];then
					DEV_IB=$IBA2
					DEV_IB_PORT="2"
				fi
				# iba2 , port 1
				if [[ $IBA2P1_S -eq "1" && $iba2p1 -eq "0" ]];then
					DEV_IB=$IBA2
					DEV_IB_PORT="1"
				fi
				# iba0 , port 2
				if [[ $IBA0P2_S -eq "1" && $iba0p2 -eq "0" ]];then
					DEV_IB=$IBA0
					DEV_IB_PORT="2"
				fi
				;;
			${IBA0},2)
				iba0p2=1
				DEV_IB=$IBA0
				DEV_IB_PORT="1"
				# iba2 , port 2
				if [[ $IBA2P2_S -eq "1" && $iba2p2 -eq "0" ]];then
					DEV_IB=$IBA2
					DEV_IB_PORT="2"
				fi
				# iba2 , port 1
				if [[ $IBA2P1_S -eq "1" && $iba2p1 -eq "0" ]];then
					DEV_IB=$IBA2
					DEV_IB_PORT="1"
				fi
				# iba0 , port 1
				if [[ $IBA0P1_S -eq "1" && $iba0p1 -eq "0" ]];then
					DEV_IB=$IBA0
					DEV_IB_PORT="1"
				fi
				;;
			${IBA2},1)
				iba2p1=1
				DEV_IB=$IBA2
				DEV_IB_PORT="2"
				# iba0 , port 2
				if [[ $IBA0P2_S -eq "1" && $iba0p2 -eq "0" ]];then
					DEV_IB=$IBA0
					DEV_IB_PORT="2"
				fi
				# iba0 , port 1
				if [[ $IBA0P1_S -eq "1" && $iba0p1 -eq "0" ]];then
					DEV_IB=$IBA0
					DEV_IB_PORT="1"
				fi
				# iba2 , port 2
				if [[ $IBA2P2_S -eq "1" && $iba2p2 -eq "0" ]];then
					DEV_IB=$IBA2
					DEV_IB_PORT="2"
				fi
				;;
			${IBA2},2)
				iba2p2=1
				DEV_IB=$IBA2
				DEV_IB_PORT="1"
				# iba0 , port 2
				if [[ $IBA0P2_S -eq "1" && $iba0p2 -eq "0" ]];then
					DEV_IB=$IBA0
					DEV_IB_PORT="2"
				fi
				# iba0 , port 1
				if [[ $IBA0P1_S -eq "1" && $iba0p1 -eq "0" ]];then
					DEV_IB=$IBA0
					DEV_IB_PORT="1"
				fi
				# iba2 , port 1
				if [[ $IBA2P1_S -eq "1" && $iba2p1 -eq "0" ]];then
					DEV_IB=$IBA2
					DEV_IB_PORT="1"
				fi
				;;
				 *)
				tlog "[WARN] IB card number has wrong message:${DEV_IB} ${DEV_IB_PORT}" $LOG
				exit 1
			;;
		esac
		tlog "[WARN] Local InfiniBand card check success, begins to swap Device:${DEV_IB} Port:${DEV_IB_PORT}" $LOG
		swap ${DEV_IB} ${DEV_IB_PORT}
#		ping_check
		return 0
	else
		tlog "[WARN] Local InfiniBand card check all failed, begins to check alternate server connection..." $LOG
			if [[ $NOW_HOST = $HOSTA ]];then
				ssh_check
				exec_status=$?
				if [[ $exec_status -eq "0" ]];then
					remote_check
				else
					tlog "[ERR] ssh_check function check sshd $HOSTB service has question" $LOG
					exit 1
				fi
			else
				tlog "[WARN] $NOW_HOST is Backup lpar, then don't move Resource Group and $0 script terminated " $LOG
				exit 1
			fi
	fi
}
#}}}

#{{{setp:8 , ssh_service check 
ssh_check() {
#set -x 
#tlog "#===========================ssh_check function....===================================#" $LOG
	ping -q -c $COUNT -w 1 -I ${HSOTA_VL4} ${HSOTB_VL4} > /dev/null 2>>$LOG 
	exec_status=$?
	if [[ $exec_status -eq "0" ]];then
		#ssh -p ${PORT} -o BatchMode=yes ${HSOTB_VL4} "ls -ld /tmp > /dev/null 2>&1"
		ssh -p ${PORT} -o BatchMode=yes ${HSOTB_VL4} "hostname > /dev/null 2>&1"
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] SSHD service check finished" $LOG
			return 0
		else
			tlog "[ERR] ${HSOTB_VL4} sshd service has question,Please to check the ${HSOTB_VL4} ssh service or ssh-key change question " $LOG
			erlogger "[ERR] ${HSOTB_VL4} sshd service has question,Please to check the ${HSOTB_VL4} ssh service or ssh-key change question "
			return $exec_status
		fi
	else
			tlog "[ERR] Network vlan_IP:$HSOTB_VL4 has the problem" $LOG	
			erlogger "[ERR] Network vlan_IP:$HSOTB_VL4 has the problem"
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
	tlog "[INFO] Detaching ib0 device..." $LOG
	erlogger "[INFO] Detaching ib0 device..."

	# detach the ib0 
	flag=1
	while [ $flag -le $CMDCYCLE ]
	do
		#use Rbac function, detach ib0
		swrole exec.chdev "-c chdev -l ib0 -a state=detach > /dev/null 2>>$LOG"
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Detach ib0 success " $LOG
			break
		else 
			flag=$(($flag + 1 ))
		fi
	done

	if [[ $flag -gt "3" ]];then
		tlog "[ERR] Detach ib0 Failed,than $0 script terminated"  $LOG
		erlogger "[ERR] Detach ib0 Failed,than $0 script terminated" 
		exit 1 
	fi

	# use new iba card to bind ip on ib0 
	flag=1
	while [ $flag -le $CMDCYCLE ]
	do
		#use Rbac function, bind ip on ib card
		swrole exec.chdev "-c chdev -l ib0 -a ib_adapter=${NEW_IB} -a ib_port=${NEW_IB_PORT} -a state=up -a netaddr=${IPADDR} -a netmask=255.255.255.0 > /dev/null 2>>$LOG"
#swrole exec.mkiba,exec.chdev "-c mkiba -a ${IPADDR} -i ib0 -A $NEW_IB -p $NEW_IB_PORT -P 0xFFFF -S up -m 255.255.255.0 -M 2044 > /dev/null 2>&1 "
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Bind ip:${IPADDR} on ib0 success " $LOG
			tlog "[INFO] Swap finished, ib0 network work on IB device Card:(${NEW_IB}) Port:(${NEW_IB_PORT}) " $LOG
			erlogger "[INFO] Swap finished, ib0 network work on IB device Card:\(${NEW_IB}\) Port:\(${NEW_IB_PORT}\)"
#			ping_check
			return 0
		else 
			flag=$(($flag + 1 ))
		fi
	done

	if [[ $flag -gt "3" ]];then
		tlog "[ERR] Bind ip:${IPADDR} on ib0 Failed,than $0 script terminated"  $LOG
		erlogger "[ERR] Bind ip:${IPADDR} on ib0 Failed,than $0 script terminated" 
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
		tlog "[WARN] ${HOSTB} ${ALT_DEV} alive, begins to transfer IP $IPADDR from $NOW_HOST to $HOSTB ..." $LOG
#		ssh -p ${PORT} ${ALT_HOST} mkiba -a ${IPADDR} -i ib0 -A ${ALT_DEV} -p 1 -P 0xFFFF -S up -m 255.255.255.0 -M 2044 > /dev/null 2>&1

		# detach the ib0 
		flag=1
		while [ $flag -le $CMDCYCLE ]
		do
			#use Rbac function , detach ib0
			swrole exec.chdev "-c chdev -l ib0 -a state=detach > /dev/null 2>>$LOG"
			exec_status=$?
			if [[ $exec_status -eq "0" ]];then
				tlog "[INFO] Detach ib0 success, begins to transfer HACMP" $LOG
				break
			else 
				flag=$(($flag + 1 ))
			fi

			if [[ $flag -gt "3" ]];then
				tlog "[ERR] Detach ib0 Failed,than $0 script terminated"  $LOG
				erlogger "[ERR] Detach ib0 Failed,than $0 script terminated" 
				exit 1 
			fi
		done

		#use Rbac function, rg move to hostb
		swrole exec.clRGmove "-c ${HADIR}/clRGmove -s 'false'  -m -i -g ${RG_NAME} -n ${HOSTB} > /dev/null 2>>$LOG"
		exec_status=$?
		if [[ $exec_status -eq 0 ]]; then
			tlog "[INFO] HACMP transfer completed, script terminated..." $LOG
			erlogger "[INFO] HACMP transfer completed, script terminated..."
		else
			tlog "[ERR] HACMP transfer failed, please check HACMP status by cldump, script terminated..." $LOG
			erlogger "[ERR] HACMP transfer failed, please check HACMP status by cldump, script terminated..."
		fi
		sleep 1
		exit 0
	else
		tlog "[ERR] We are not going to move ; $NOW_HOST and $HOSTB physical connections all fail, script terminate" $LOG
		sleep 1
		exit 0
	fi
}
#}}}

main
