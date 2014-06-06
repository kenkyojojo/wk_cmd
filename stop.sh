#!/usr/bin/ksh
SHELL="/home/tse/twse/script"
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
