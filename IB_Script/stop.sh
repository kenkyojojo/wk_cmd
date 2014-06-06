#!/usr/bin/ksh
SHELL="/TWSE/shell"
CTRLM="/TWSE/ControlM/ctm/scripts"
APPIA="/TWSE/FIXCTL/shell/Failover"
LOGDIR="/var/hacmp/log"
LOG=${LOGDIR}/ha_start_stop.sh.log
#=====================================================================#


#{{{tlog ,script loger function
tlog() {

    MSG=$1
    LOG=$2
	dt=`date +"%Y/%m/%d %H:%M:%S"`

	echo "$SITE [${dt}] $MSG" | tee  -a $LOG
}
#}}}

#{{{appia_stop
appia_stop () {

	if [[ -x ${APPIA}/Stop_Task.sh ]];then
		tlog "[INFO] The ${APPIA}/Stop_Task.sh is exist and is executable" $LOG	
		su - twse "-c ${APPIA}/Stop_Task.sh FIXGW01 > /dev/null "
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Execute the ${APPIA}/Stop_Task.sh Success" $LOG	
		else
			tlog "[ERR] Execute the ${APPIA}/Stop_Task.sh Failed" $LOG	
		fi
	else
		tlog "[ERR] The ${APPIA}/Stop_Task.sh is not exist or not executable" $LOG	
	fi
}
#}}}

#{{{ctrlm_stop
ctrlm_stop () {

	if [[ -x ${CTRLM}/start-ag ]];then
		tlog "[INFO] The ${CTRLM}/start-ag is exist and is executable" $LOG	
		su - twse "-c ${CTRLM}/shut-ag -u twse -p all "
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Execute the ${CTRLM}/start-ag Success" $LOG	
		else
			tlog "[ERR] Execute the ${CTRLM}/start-ag Failed" $LOG	
		fi

	else
		tlog "[ERR] The ${CTRLM}/start-ag is not exist or not executable" $LOG	
	fi
}
#}}}

#{{{ib_stop
ib_stop () {

	if [[ -x ${SHELL}/ib_stop.sh ]];then
		tlog "[INFO] The ${SHELL}/ib_stop.sh is exist and is executable" $LOG	
		su - twse "-c ${SHELL}/ib_stop.sh"
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Execute the ${SHELL}/ib_stop.sh Success" $LOG	
		else
			tlog "[ERR] Execute the ${SHELL}/ib_stop.sh Failed" $LOG	
		fi

	else
		tlog "[ERR] The ${SHELL}/ib_stop.sh is not exist or not executable" $LOG	
	fi
}
#}}}

#{{{main
main () {
	tlog "***************************Power_HA Stop.sh begins**********************************" $LOG
	# InfiniBand Card detection script to start
	ib_stop
}
#}}}

main
