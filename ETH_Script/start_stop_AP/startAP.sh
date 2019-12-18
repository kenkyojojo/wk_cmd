#!/usr/bin/ksh
SHELL="/TWSE/bin/TWSE/HA_script"
CTRLM="/TWSE/ControlM/ctm/scripts"
APPIA="/TWSE/FIXCTL/shell/Failover"
APPIA_Parameter_FIX1="FIXGW01"
APPIA_Parameter_FIX2="FIXGW02"
APPIA_Parameter_TS1="TS1"
LOGDIR="/var/hacmp/log"
IBMON="/TWSE/bin"
HOSTNAME=`hostname`
HOST=$(echo $HOSTNAME | cut -c 1-10)
FIX01="FIXGW01"
LOG=${LOGDIR}/ha_start_stop.sh.log
#=====================================================#

#{{{tlog ,script loger function
tlog() {

    MSG=$1
    LOG=$2
	dt=`date +"%Y/%m/%d %H:%M:%S"`

	echo "$SITE [${dt}] $MSG" | tee -a $LOG
}
#}}}

#{{{ib_start
ib_start () {
TYPE=$1
IB_TYPE=$2
	if [[ -x ${SHELL}/ib_start.sout ]];then
		tlog "[INFO] The ${SHELL}/ib_start.sout is exist and is executable" $LOG	
		su - twse "-c nohup ${SHELL}/ib_start.sout $TYPE $IB_TYPE > /dev/null 2>&1 &"
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Execute the ${SHELL}/ib_start.sout $TYPE $IB_TYPE Success" $LOG	
		else
			tlog "[ERR] Execute the ${SHELL}/ib_start.sout $TYPE $IB_TYPE Failed" $LOG	
		fi
	else
		tlog "[ERR] The ${SHELL}/ib_start.sout is not exist or not executable" $LOG	
	fi
}
#}}}

#{{{eth_start
eth_start () {
TYPE=$1
	if [[ -x ${SHELL}/eth_start.sout ]];then
		tlog "[INFO] The ${SHELL}/eth_start.sout is exist and is executable" $LOG	
		su - twse "-c nohup ${SHELL}/eth_start.sout $TYPE > /dev/null 2>&1 &"
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Execute the ${SHELL}/eth_start.sout $TYPE Success" $LOG	
		else
			tlog "[ERR] Execute the ${SHELL}/eth_start.sout $TYPE Failed" $LOG	
		fi
	else
		tlog "[ERR] The ${SHELL}/eth_start.sout is not exist or not executable" $LOG	
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
APPIA_Parameter=$1

	if [[ -x ${APPIA}/Startup_Task.sh ]];then
		tlog "[INFO] The ${APPIA}/Startup_Task.sh is exist and is executable" $LOG	
		su - twse "-c ${APPIA}/Startup_Task.sh $APPIA_Parameter > /dev/null "
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Execute the ${APPIA}/Startup_Task.sh $APPIA_Parameter Success" $LOG	
		else
			tlog "[ERR] Execute the ${APPIA}/Startup_Task.sh $APPIA_Parameter Failed" $LOG	
		fi

	else
		tlog "[ERR] The ${APPIA}/Startup_Task.sh is not exist or not executable" $LOG	
	fi
}
#}}}

#{{{main
main () {
	tlog "***************************Power_HA Start.sh begins**********************************" $LOG
	# ib_start.sout to start
	ib_start TWSE QDR
	# eth_start.sout to start
	eth_start TWSE
	# appia to start
	if [[ $HOST == $FIX01 ]];then
		appia_start $APPIA_Parameter_TS1
		appia_start $APPIA_Parameter_FIX1
	else
		appia_start $APPIA_Parameter_FIX2
	fi
	# ctrlM to start
	ctrlm_start
}
#}}}

main
