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
#   1. Collocation the Power HA. This program to detention "Infinband card" and IB network status. 
#
# History:
# 2014/04/29 Bruce 	First  release, To detach the ib0 card.
# 2014/05/03 Bruce 	second release, To kill
#
# version:
# 1.0 release
# 1.1 release, if have 2 or more ib_start.sh process , loop to kill it.
# 
#set -x 

SITE="TSEOT2"
NOW_HOST=$(hostname)
FAILCYCLE="2"
LOGDIR=/home/tse/twse/script_log
LOG=${LOGDIR}/ib_start_stop.sh.log
SHNAME="ib_start.sh"
set -A MUSER twse
#-----------------------------------------------------------------------------#

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

#{{{tlog ,script loger function
tlog() {

    MSG=$1
    LOG=$2
	dt=`date +"%Y/%m/%d %H:%M:%S"`

	echo "$SITE [${dt}] $MSG" | tee  -a $LOG
}
#}}}

#{{{errlogger to aix errpt log 
erlogger() {

    MSG=$1
	#use Rbac function.
	swrole exec.errlogger "-c errlogger $MSG"
}
#}}}

#{{{step:1 , main
main () {

	tlog "***************************InfiniBand monitor stop************************************" $LOG
	# check execute user is twse
	user_check
	exec_status=$?
	if [[ $exec_status -eq "0"  ]];then	
		# deatch the ib0 card
		detach
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Detach function execute Success" $LOG
		else 
			tlog "[ERR] Detach ib0 Failed"  $LOG
			erlogger "[ERR] Detach ib0 Failed" 
		fi

		# kill the ib_start.sh script
		ib_script_stop
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Terminated ib_start.sh script Success" $LOG
		else 
			tlog "[ERR] Terminated ib_start.sh script Failed" $LOG
			erlogger "[ERR] Terminated ib_start.sh script Failed"
		fi
	else
		tlog "[ERR] $USER permission denied, than $0 script terminated" $LOG
		exit 1
	fi

	exit 0
}
#}}}

#{{{setp:2 , detach ib interface
detach() {
#set -x 
#tlog "#==========================detach_...================================================#" $LOG

	tlog "[INFO] Detaching ib0 device..." $LOG

	# detach the ib0 
	flag=1
	while [ $flag -le $FAILCYCLE ]
	do
		# use Rbac function, detach ib0
		swrole exec.chdev "-c chdev -l ib0 -a state=detach > /dev/null 2>&1"
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Detach ib0 success " $LOG
			return 0
		else 
			flag=$(($flag + 1 ))
		fi
	done

	if [[ $flag -gt $FAILCYCLE ]];then
		return 1 
	fi
}
#}}}

#{{{setp:3 , ib_script_stop
ib_script_stop() {
#set -x 
#tlog "#==========================ib_script_stop...================================================#" $LOG

	tlog "[INFO] Terminated ib_start.sh script start" $LOG
	
	PIDNUM=$(ps -ef | grep $SHNAME | grep -v grep | awk '{print $2}')

	if [[ ! -n $PIDNUM ]];then
		tlog "[INFO] The ib_start.sh script PID already is empty" $LOG
		return 0
	fi
	# kill the ib_start.sh process
	flag=1
	while [ $flag -le $FAILCYCLE ]
	do
		# if have 2 the same process,loop to kill the process
		for PID in $PIDNUM
		do
			kill -9 $PID
		done

		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			return 0
		else 
			flag=$(($flag + 1 ))
		fi
	done

	if [[ $flag -gt $FAILCYCLE ]];then
		return 1 
	fi
}
#}}}

main
