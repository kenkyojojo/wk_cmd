#!/usr/bin/ksh
SHELL="/TWSE/shell"
CTRLM="/TWSE/ControlM/ctm/scripts"
APPIA="/TWSE/FIXCTL/shell/Failover"
LOGDIR="/var/hacmp/log"
IBMON="/tmp/ib_script_monitor/release"
LOG=${LOGDIR}/ha_start_stop.sh.log
#=====================================================#

#{{{tlog ,script loger function
tlog() {

    MSG=$1
    LOG=$2
	dt=`date +"%Y/%m/%d %H:%M:%S"`

	echo "$SITE [${dt}] $MSG" | tee  -a $LOG
}
#}}}

#{{{ibsmon_np
ib_smon() {

	if [[ -x ${IBMON}/ibsmon_np ]];then
		tlog "[INFO] The ${IBMON}/ibsmon_np is exist and is executable" $LOG	
		#	                              Notify_file times * sec = 1 times/30sec
		su - twse "-c ${IBMON}/ibsmon_np /tmp/ib_moni   1     30"
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Execute the ${IBMON}/ibsmon_np Success" $LOG	
		else
			tlog "[ERR] Execute the ${IBMON}/ibsmon_np Failed" $LOG	
		fi
	else
		tlog "[ERR] The ${IBMON}/ibsmon_np is not exist or not executable" $LOG	
	fi
}
#}}}

#{{{ib_start
ib_start () {

	if [[ -x ${SHELL}/ib_start.sh ]];then
		tlog "[INFO] The ${SHELL}/ib_start.sh is exist and is executable" $LOG	
		su - twse "-c nohup ${SHELL}/ib_start.sh > /dev/null 2>&1 &"
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Execute the ${SHELL}/ib_start.sh Success" $LOG	
		else
			tlog "[ERR] Execute the ${SHELL}/ib_start.sh Failed" $LOG	
		fi

	else
		tlog "[ERR] The ${SHELL}/ib_start.sh is not exist or not executable" $LOG	
	fi
}
#}}}

#{{{ctrm_start
ctrlm_start () {

	if [[ -x ${CTRLM}/start-ag ]];then
		tlog "[INFO] The ${CTRLM}/start-ag is exist and is executable" $LOG	
		su - twse "-c ${CTRLM}/start-ag -u twse -p all"
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

#{{{appia_start
appia_start () {

	if [[ -x ${APPIA}/FIXCTL_start ]];then
		tlog "[INFO] The ${APPIA}/FIXCTL_start.sh is exist and is executable" $LOG	
		su - twse "-c ${APPIA}/FIXCTL_start FIXGW01 > /dev/null "
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Execute the ${APPIA}/FIXCTL_start Success" $LOG	
		else
			tlog "[ERR] Execute the ${APPIA}/FIXCTL_start Failed" $LOG	
		fi

	else
		tlog "[ERR] The ${APPIA}/FIXCTL_start is not exist or not executable" $LOG	
	fi
}
#}}}

#{{{main
main () {
	tlog "***************************Power_HA Stat.sh begins**********************************" $LOG
	# ib_smon moniter
	ib_smon
	# ib_start.sh to start
	ib_start
	# ctrlM to start
	ctrlm_start
	# appia to start
	appia_start
}
#}}}

main
