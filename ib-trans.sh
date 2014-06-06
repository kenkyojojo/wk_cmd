#!/usr/bin/ksh 
#The following line will enable tracing for all functions in a script
#typeset -ft $(typeset +f)

SITE="TSEOT1"
INTERVAL="5"
IPADDR="192.168.100.50"
DESIPR="192.168.100.1"
HOSTA="OAT2_C1"
HOSTB="OAT2_C2"
RG_NAME="OAT2_1_RG"
COUNT="3"
FAILCYCLE="3"
HACYCLE="6"
NOW_HOST=$(hostname)
PORT="2222"
LOG=/tmp/ib-trans.log
IBA="iba"
IBA0="iba0"
IBA1="iba1"
IBA2="iba2"
IBA3="iba3"
haflag="1"

#-----------------------------------------------------------------------------#

#{{{tlog ,script loger function
tlog() {

    MSG=$1
    LOG=$2
	dt=`date +"%y/%m/%d %H:%M:%S"`

	echo "$SITE [${dt}] $MSG" | tee  -a $LOG
}
#}}}

#{{{errlogger to aix errpt log 
erlogger() {

    MSG=$1
	errlogger $MSG
}
#}}}

#{{{check_ib_ip_status , step 2
check_ib_ip_status () {
tlog "check_ib_ip_status" $LOG
	#check the ib card does have bind the ip
	ifconfig ib0 | grep ${IPADDR}[[:space:]] > /dev/null 2>&1

	#if exec_status = 0 , than check ib hwstatus else no ip setting than execute the ib_ip_config to set ip address on ib card
	exec_status=$?
	if [[ $exec_status -eq "0" ]]
		tlog "[INFO] execute check_ib_hwstatus function Start" $LOG
		check_ib_hwstatus
		exec_status=$?
		if [[ $exec_status -eq "0" ]]
			tlog "[INFO] check_ib_hwstatus function Success" $LOG
		else 
			tlog "[ERR] check_ib_hwstatus function Failed" $LOG
		fi
		tlog "[INFO] Execute check_ib_hwstatus function Finished" $LOG
	else
		tlog "[INFO] Need to Bind the ip:${IPADDR} on Infiniband card" $LOG
		#ib_ip_config function to set ip address on ib card
		tlog "[INFO] execute ib_ip_config function Start" $LOG
		ib_ip_conifg	
		exec_status=$?
		if [[ $exec_status -eq "0" ]]
			tlog "[INFO] execute ib_ip_config function Success" $LOG
			#to exit the rbac level,need to check can do it ?
			exit 0
		else 
			tlog "[ERR] execute ib_ip_config function Failed" $LOG
			exit 1
			exit 1
		fi
	fi
}
#}}}

#{{{ib_ip_conifg , step 3
ib_ip_conifg () {
tlog "ib_ip_conifg" $LOG
		#privilege permitted to the users
		tlog "[INFO] execute rbac_config function Start" $LOG
		rbac_config
		exec_status=$?
		if [[ $exec_status -eq "0" ]]
			tlog "[INFO] execute rbac_config function Success" $LOG
		else 
			tlog "[ERR] RBAC config setting has question,than $0 script terminated" $LOG
			erlogger "[ERR] RBAC config setting has question,than $0 script terminated"
			exit 1
			exit 1
		fi

		#search the first Available ib card
		DEV_IB=$(lsdev -Cc adapter | grep 'iba.[[:space:]]' | grep 'Available' | head -1 | awk '{print $1}')

		tlog "[INFO] Bind ip on ib0 device from device ${DEV_IB}..." $LOG

		#set ip address on ib card
		mkiba -a ${IPADDR} -i ib0 -A ${DEV_IB} -p 1 -P 0xFFFF -S up -m 255.255.255.0 -M 2044 > /dev/null 2>&1
		exec_status=$?
		if [[ $exec_status -eq "0" ]]
			erlogger "Bind the ip:${IPADDR} on ib Finished"
			tlog "Bind the ip:${IPADDR} on ib Finished" $LOG
			return 0
		else 
			erlogger "Bind the ip:${IPADDR} on ib Failed"
			tlog "Bind the ip:${IPADDR} on ib Failed" $LOG
			return $exec_status
		fi

}
#}}}

#{{{swap
swap() {
tlog "swap" $LOG

	NEW_IB=$1
	tlog "[INFO] Detaching ib0 device from $1..." $LOG
	erlogger "[INFO] Detaching ib0 device from $1..."

	#privilege permitted to the users
		tlog "[INFO] execute rbac_config function Start" $LOG
		rbac_config
		exec_status=$?
		if [[ $exec_status -eq "0" ]]
			tlog "[INFO] execute rbac_config function Success" $LOG
		else 
			tlog "[ERR] RBAC config setting has question,than $0 script terminated" $LOG
			erlogger "[ERR] RBAC config setting has question,than $0 script terminated"
			exit 1
			exit 1
		fi

	# detach the ib0 
	flag=1
	while [[ $flag -le "3" ]] 
	do
		chdev -l ib0 -a status=detach > /dev/null 
		exec_status=$?
		if [[ $exec_status -eq "0" ]]
			tlog "[INFO] detach ib0 success " $LOG
			break
		else 
			flag=$(($flag + 1 ))
		fi
	done

	if [[ $flag -gt "3" ]];then
		tlog "[ERR] detach ib0 Failed,than $0 script terminated"  $LOG
		erlogger "[ERR] detach ib0 Failed,than $0 script terminated" 
		exit 1 
	fi

	# use new iba card to bind ip on ib0 
	flag=1
	while [[ $flag -le "3" ]] 
	do
		mkiba -a ${IPADDR} -i ib0 -A $NEW_IB -p 1 -P 0xFFFF -S up -m 255.255.255.0 -M 2044 > /dev/null 2>&1
		exec_status=$?
		if [[ $exec_status -eq "0" ]]
			tlog "[INFO] bind ip:${IPADDR} on ib0 success " $LOG
			break
		else 
			flag=$(($flag + 1 ))
		fi
	done

	if [[ $flag -gt "3" ]];then
		tlog "[ERR] bind ip:${IPADDR} on ib0 Failed,than $0 script terminated"  $LOG
		erlogger "[ERR] bind ip:${IPADDR} on ib0 Failed,than $0 script terminated" 
		exit 1 
	fi

	tlog "[INFO] Done, ib0 working on $NEW_IB" $LOG
	erlogger "[INFO] Done, ib0 working on  $NEW_IB"

}
#}}}

#{{{ping_check , setp 6
ping_check() {
tlog "ping_check" $LOG

	if [[ ! -z $1 ]];then
		DESIP=$1
	else
		DESIP=$DESIPR
	fi
	
	LOSS=$(ping -q -c $COUNT -w 1 $DESIP | grep loss | cut -d '%' -f 1 | awk '{print $NF}')
	#if ib network perfect,than skip the flowing step,and reset the haflag
	if [[ $LOSS -eq "0" ]];then
		ssh_check
		haflag=1
		return 0
	fi

	flag=1
	# commit FAILCYCLE="3"
	while [[ $flag -le $FAILCYCLE ]]
	do
		if [[ $LOSS -eq "100" ]];then
			tlog "[ERR] ${LOSS}% packet loss" $LOG	
			erlogger "[ERR] ${LOSS}% packet loss"
			LOSS=$(ping -q -c $COUNT -w 1 $DESIP | grep loss | cut -d '%' -f 1 | awk '{print $NF}')
			if [[ $LOSS -eq "0" ]];then
				tlog "[INFO] IB network status recover" $LOG	
				haflag=1
				return 0
			fi

			if [[ $flag -eq "3"  ]];then
				loss_100_ib_hwstatus
			fi
			# if 2 ib card loss are 100% , than RG move to the HOSTB
			# commit HACYCLE="6"
			if [[ $haflag -eq $HACYCLE ]];then
				if [[ $NOW_HOST = "$HOSTA" ]];then
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

			flag=$(($flag+1))
			haflag=$(($haflag+1))
		else 
			tlog "[ERR] ${LOSS}% packet loss" $LOG	
			erlogger "[ERR] ${LOSS}% packet loss"
			flag=$(($flag+1))
			LOSS=$(ping -q -c $COUNT -w 1 $DESIP | grep loss | cut -d '%' -f 1 | awk '{print $NF}')
			if [[ $LOSS -eq "0" ]];then
				ssh_check
				tlog "[INFO] IB network status recover" $LOG	
				return 0
			fi
		fi
	done
}
#}}}

#{{{rbac_config
rbac_config(){
tlog "rbac_config" $LOG
	swrole SecPolicy,sa
	exec_status=$?
	if [[ $exec_status -eq "0" ]];then
		return 0
	else
		return $exec_status
	fi
}
#}}}

#{{{ssh_service_check
ssh_check() {
tlog "ssh_check function...." $LOG
HSOTBVL4="10.199.168.111"
	ssh -p ${PORT} -o BatchMode=yes ${HOSTBV4} "ls -ld /tmp" > /dev/null 2>&1
	exec_status=$?
	if [[ $exec_status -eq "0" ]];then
		return 0
	else
		tlog "[ERR] ${HOSTBVL4} sshd service has question,Please to check the ${HOSTBVL4} ssh service or ssh-key change question " $LOG
		erlogger "[ERR] ${HOSTBVL4} sshd service has question,Please to check the ${HOSTBVL4} ssh service or ssh-key change question "
		return $exec_status
	fi
}
#}}}

#{{{remote_check
remote_check() {
tlog "remote_check function..." $LOG
	ALT_DEV=$(ssh -p ${PORT} ${HOSTB} ibstat |grep Active | head -1 | awk '{print $3}' | tr -d "()" )
	if [[ ${ALT_DEV} = iba[0-9] ]]; then
		tlog "[WARN] ${HOSTB} ${ALT_DEV} alive, begins to transfer IP $IPADDR from $NOW_HOST to $HOSTB ..." $LOG
#		ssh -p ${PORT} ${ALT_HOST} mkiba -a ${IPADDR} -i ib0 -A ${ALT_DEV} -p 1 -P 0xFFFF -S up -m 255.255.255.0 -M 2044 > /dev/null 2>&1

		# detach the ib0 
		flag=1
		while [[ $flag -le "3" ]] 
		do
			chdev -l ib0 -a status=detach
			exec_status=$?
			if [[ $exec_status -eq "0" ]]
				tlog "[INFO] detach ib0 success, begins to transfer HACMP" $LOG
				break
			else 
				flag=$(($flag + 1 ))
			fi
		done

		if [[ $flag -gt "3" ]];then
			tlog "[ERR] detach ib0 Failed,than $0 script terminated"  $LOG
			erlogger "[ERR] detach ib0 Failed,than $0 script terminated" 
			exit 1 
		fi

		/usr/es/sbin/cluster/utilities/clRGmove -s 'false'  -m -i -g ${RG_NAME} -n ${HOSTB} >> /dev/null 2>&1
		exec_status=$?
		if [[ $exec_status -eq 0 ]]; then
			tlog "[INFO] HACMP transfer completed, script terminated..." $LOG
			erlogger "[INFO] HACMP transfer completed, script terminated..."
		else
			tlog "[ERR] HACMP transfer failed, please check HACMP status by cldump, script terminated..." $LOG
			erlogger "[ERR] HACMP transfer failed, please check HACMP status by cldump, script terminated..."
		fi
		exit 0
	else
		tlog "[ERR] We are not going to move ; $NOW_HOST and $ALT_HOST physical connections all fail, script terminate" $LOG
		exit 0
	fi
}
#}}}

#{{{local_check , step 5
local_check() {
tlog "local_check function..." $LOG
	tlog "[INFO] Executing Local check" $LOG

	ibstat $1 | grep Active > /dev/null 2>&1
	exec_status=$?
	if [[ $exec_status -eq "0" ]]
		return 0
	else 
		return $exec_status
	fi
}
#}}}

#{{{check_ib_hwstatus , step 4
check_ib_hwstatus() {
tlog "check_ib_hwstatus function..." $LOG

	DEV_NOW=$(lsattr -El ib0 |grep adapter | awk '{print $2}')

	local_check ${DEV_NOW}

	exec_status=$?
	if [[ $exec_stauts -eq 0 ]]; then
		tlog "[INFO] ${IPADDR} on ${DEV_NOW} check ok, sleep for ${INTERVAL} seconds..." $LOG
		ping_check
		sleep ${INTERVAL}
#		check_ib_ip_status
	else
		# Check ib card status is active, if don't then execute remote_check function.
		DEV_ACT_CUNT=$(ibstat | grep Active | wc -l)

		if [[ $DEV_ACT_CUNT -gt 0 ]]; then
			#Check which ib card status is failed.
			DEV_NACT=$(ibstat | grep -v Active | tail -1 |awk '{print $1}') 
			case $DEV_NACT in 
				iba0)
					lsdev -Cc adapter | grep "$IBA1[[:space:]]" | grep 'Available'
					exec_status=$?
					if [[ $exec_status -eq "0" ]]; then
						DEV_IB=$(lsdev -Cc adapter | grep "${IBA1}[[:space:]]" | grep 'Available' | head -1 | awk '{print $1}')
					else 
						DEV_IB=$(lsdev -Cc adapter | grep "${IBA}.[[:space:]]" | grep 'Available' | head -1 | awk '{print $1}')
					fi
					;;
				iba1)
					lsdev -Cc adapter | grep "$IBA0[[:space:]]" | grep 'Available'
					exec_status=$?
					if [[ $exec_status -eq "0" ]]; then
						DEV_IB=$(lsdev -Cc adapter | grep "${IBA0}[[:space:]]" | grep 'Available' | head -1 | awk '{print $1}')
					else 
						DEV_IB=$(lsdev -Cc adapter | grep "${IBA}.[[:space:]]" | grep 'Available' | head -1 | awk '{print $1}')
					fi
					;;
				iba2)
					lsdev -Cc adapter | grep "$IBA3[[:space:]]" | grep 'Available'
					exec_status=$?
					if [[ $exec_status -eq "0" ]]; then
						DEV_IB=$(lsdev -Cc adapter | grep "${IBA3}[[:space:]]" | grep 'Available' | head -1 | awk '{print $1}')
					else 
						DEV_IB=$(lsdev -Cc adapter | grep "${IBA}.[[:space:]]" | grep 'Available' | head -1 | awk '{print $1}')
					fi
					;;
				iba3)
					lsdev -Cc adapter | grep "$IBA2[[:space:]]" | grep 'Available'
					exec_status=$?
					if [[ $exec_status -eq "0" ]]; then
						DEV_IB=$(lsdev -Cc adapter | grep "${IBA2}[[:space:]]" | grep 'Available' | head -1 | awk '{print $1}')
					else 
						DEV_IB=$(lsdev -Cc adapter | grep "${IBA}.[[:space:]]" | grep 'Available' | head -1 | awk '{print $1}')
					fi
					;;
				*)
					tlog "[WARN] IB card number has wrong message:${DEV_IB}" $LOG
					exit 1
				;;
			esac
			tlog "[WARN] Local check success, begins to swap device ${DEV_IB}" $LOG

			#privilege permitted to the users
			tlog "[INFO] execute rbac_config function Start" $LOG
			swap ${DEV_IB} 
		else 
			tlog "[WARN] Local check all failed, begins to check alternate server connection..." $LOG
			if [[ $NOW_HOST = "$HOSTA" ]];then
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

		sleep ${INTERVAL}
		check_ib_ip_status
	fi
}
#}}}

#{{{loss_100_ib_hwstatus
loss_100_ib_hwstatus() {
tlog "loss_100_ib_hwstatus function..." $LOG

	DEV_NOW=$(lsattr -El ib0 |grep adapter | awk '{print $2}')
	$tlog "loss_100_ib_hwstatus:$DEV_NOW" $LOG
		case $DEV_NOW in 
			iba0|iba1)
				lsdev -Cc adapter | grep "$IBA2[[:space:]]" | grep 'Available'
				exec_status=$?
				if [[ $exec_status -eq "0" ]]; then
					DEV_IB=$(lsdev -Cc adapter | grep "${IBA2}[[:space:]]" | grep 'Available' | head -1 | awk '{print $1}')
				else 
					DEV_IB=$(lsdev -Cc adapter | grep "${IBA3}[[:space:]]" | grep 'Available' | head -1 | awk '{print $1}')
				fi
				;;
			iba2|iba3)
				lsdev -Cc adapter | grep "$IBA0[[:space:]]" | grep 'Available'
				exec_status=$?
				if [[ $exec_status -eq "0" ]]; then
					DEV_IB=$(lsdev -Cc adapter | grep "${IBA0}[[:space:]]" | grep 'Available' | head -1 | awk '{print $1}')
				else 
					DEV_IB=$(lsdev -Cc adapter | grep "${IBA1}[[:space:]]" | grep 'Available' | head -1 | awk '{print $1}')
				fi
				;;
			*)
				tlog "[WARN] IB card number has wrong message:${DEV_IB}" $LOG
				exit 1
			;;
		esac
		tlog "[WARN] begins to swap device ${DEV_IB}" $LOG
		swap ${DEV_IB} 
#		ping_check
}
#}}}

#{{{main , step 1
main () {
tlog "main function..." $LOG

	while [[ true ]]
	do
		tlog "\n\n\n" >> $LOG
		tlog "**************InfiniBand monitor begins*****************" $LOG
		tlog "[INFO] Primary host is $NOW_HOST, Alternative host $ALT_HOST" $LOG
		check_ib_ip_status
	done
}
#}}}

main
