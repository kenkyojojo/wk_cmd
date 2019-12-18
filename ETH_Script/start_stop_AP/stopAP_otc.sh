#!/usr/bin/ksh
SHELL="/OTC/bin/OTC/HA_script"
CTRLM="/OTC/ControlM/ctm/scripts"
APPIA="/OTC/FIXCTL/shell/Failover"
APPIA_Parameter_FIX1="FIXGW01"
APPIA_Parameter_FIX2="FIXGW02"
APPIA_Parameter_TS1="TS1"
HOSTNAME=`hostname`
HOST=$(echo $HOSTNAME | cut -c 1-10)
FIX01="OTCFIXGW01"
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
APPIA_Parameter=$1

	if [[ -x ${APPIA}/Stop_Task.sh ]];then
		tlog "[INFO] The ${APPIA}/Stop_Task.sh is exist and is executable" $LOG	
		su - otc "-c ${APPIA}/Stop_Task.sh $APPIA_Parameter > /dev/null "
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Execute the ${APPIA}/Stop_Task.sh $APPIA_Parameter Success" $LOG	
		else
			tlog "[ERR] Execute the ${APPIA}/Stop_Task.sh $APPIA_Parameter Failed" $LOG	
		fi
	else
		tlog "[ERR] The ${APPIA}/Stop_Task.sh is not exist or not executable" $LOG	
	fi
}
#}}}

#{{{ctrlm_stop
ctrlm_stop () {

	if [[ -x ${CTRLM}/shut-ag ]];then
		tlog "[INFO] The ${CTRLM}/shut-ag is exist and is executable" $LOG	
		su - otc "-c ${CTRLM}/shut-ag -u otc -p all "
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Execute the ${CTRLM}/shut-ag Success" $LOG	
		else
			tlog "[ERR] Execute the ${CTRLM}/shut-ag Failed" $LOG	
		fi
	else
		tlog "[ERR] The ${CTRLM}/shut-ag is not exist or not executable" $LOG	
	fi
}
#}}}

#{{{ib_stop
ib_stop () {
# TYPE：OTC or TWSE
TYPE=$1
# IB_TYPE：DDR or QDR
IB_TYPE=$2

	if [[ -x ${SHELL}/ib_stop.sout ]];then
		tlog "[INFO] The ${SHELL}/ib_stop.sout is exist and is executable" $LOG	
		su - otc "-c ${SHELL}/ib_stop.sout $TYPE $IB_TYPE > /dev/null 2>&1 "
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Execute the ${SHELL}/ib_stop.sout $TYPE $IB_TYPE Success" $LOG	
		else
			tlog "[ERR] Execute the ${SHELL}/ib_stop.sout $TYPE $IB_TYPE Failed" $LOG	
		fi
	else
		tlog "[ERR] The ${SHELL}/ib_stop.sout is not exist or not executable" $LOG	
	fi
}
#}}}

#{{{eth_stop
eth_stop () {
# TYPE：OTC or TWSE
TYPE=$1

	if [[ -x ${SHELL}/eth_stop.sout ]];then
		tlog "[INFO] The ${SHELL}/eth_stop.sout is exist and is executable" $LOG	
		su - otc "-c ${SHELL}/eth_stop.sout $TYPE > /dev/null 2>&1 "
		exec_status=$?
		if [[ $exec_status -eq "0" ]];then
			tlog "[INFO] Execute the ${SHELL}/eth_stop.sout $TYPE Success" $LOG	
		else
			tlog "[ERR] Execute the ${SHELL}/eth_stop.sout $TYPE Failed" $LOG	
		fi
	else
		tlog "[ERR] The ${SHELL}/eth_stop.sout is not exist or not executable" $LOG	
	fi
}
#}}}

#{{{main
main () {
	tlog "***************************Power_HA Stop.sh begins**********************************" $LOG
	# appia to stop
	if [[ $HOST == $FIX01 ]];then
		appia_stop $APPIA_Parameter_FIX1
		appia_stop $APPIA_Parameter_TS1
	else
		appia_stop $APPIA_Parameter_FIX2
	fi
	# ctrlm_stop to stop
	ctrlm_stop
	# InfiniBand Card detection script to stop
	ib_stop OTC QDR
	# stop to moni eth
	eth_stop OTC
}
#}}}

main
