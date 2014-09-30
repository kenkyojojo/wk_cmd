#!/usr/bin/ksh

#{{{ Parameter setting
SITE="TSEOB1"
USER=$(whoami)
LOGDIR="/var/hacmp/log"
LOG="${LOGDIR}/ha_start_stop.sh.log"

set -A MUSER root 
#}}}

#{{{tlog ,script loger function
tlog() {

    MSG=$1
    LOG=$2
	dt=$(date +"%Y/%m/%d %H:%M:%S")

	echo "$SITE [${dt}] $MSG" | tee  -a $LOG

	rc=$?
	if [[ $rc -ne "0" ]]; then
		echo "Please to check the LOG:$LOG"
		return 1
	else 
		return 0
	fi
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

#{{{init the ib ip use chdev
init_ib_ip () {

		tlog "Detach ib0 start" $LOG
		chdev -l ib0 -a state=detach > /dev/null 2>>$LOG
		rc=$?
		if [[ $rc -ne "0" ]]; then
			tlog "Please to check the ib0 ip" $LOG
			return 1
		else 
			tlog "Detach ib0 finished and successed" $LOG
			return 0
		fi
}

#}}}

#{{{step:1 , main
main () {
		echo "\n" | tee -a $LOG
		tlog "***************************InfiniBand init ip begins**********************************" $LOG
		#check exec user is twse
		user_check
		rc=$?
		if [[ $rc -eq "0"  ]];then	
			init_ib_ip
		else
			echo "[ERR] $USER permission denied, than $0 script terminated" $LOG
			exit 1
		fi
}
#}}}

main

exit 0
