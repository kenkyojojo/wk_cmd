#!/usr/bin/ksh
IB_DIR="/TWSE/shell"
#IB_MONI_DIR="/tmp/ib_script_moniter"
#IB_MONI_DIR_RS="${IB_MONI_DIR}/release"
IB_MONI_DIR="/TWSE/bin"
HA_DIR="/home"
EXADM_OWN="exadm:exc"
IB_SHELL="ib_start.sh ib_stop.sh switch_ha.sh"
HA_SHELL="startAP.sh stopAP.sh twse_rbac.sh"
IB_MONI="ibsmon_np_client ibsmon_np"
#                       1        2           3
#set -A TWSE_DIR_LIST $IB_DIR $IB_MONI_DIR $IB_MONI_DIR_RS $HA_DIR
set -A TWSE_DIR_LIST $IB_DIR $IB_MONI_DIR $HA_DIR
LOGDIR="/tmp"
LOG="${LOGDIR}/ib_script_install.log"

set -A MUSER root 

#{{{tlog ,script loger function
tlog() {

    MSG=$1
    LOG=$2
	dt=$(date +"%Y/%m/%d %H:%M:%S")

	echo "$SITE [${dt}] $MSG" | tee  -a ${LOG}
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

#{{{mk_dir
mk_dir () {
	for DIR in ${TWSE_DIR_LIST[@]}
	do
		if [[ ! -d ${DIR} ]];then
			tlog "mkdir $DIR" $LOG
			mkdir $DIR
			tlog "chown $EXADM_OWN $DIR" $LOG
			chown $EXADM_OWN $DIR
		else
			tlog "The $DIR dir is already have it" $LOG
		fi
	done
}
#}}}

#{{{install
install () {

	#IB script
	for PG in ${IB_SHELL[@]}
	do
		if [[ -f $PG ]];then
			tlog "cp $PG $IB_DIR" $LOG
			cp $PG $IB_DIR
			tlog "chown $EXADM_OWN ${IB_DIR}/${PG}" $LOG
			chown $EXADM_OWN ${IB_DIR}/${PG}
			tlog "chmod 775 ${IB_DIR}/${PG}" $LOG
			chmod 775 ${IB_DIR}/${PG}
		else
			tlog "Please to check the $PG" $LOG
		fi
	done

	#Power HA script
	for PG in ${HA_SHELL[@]}
	do
		if [[ -f $PG ]];then
			tlog "cp $PG $HA_DIR" $LOG
			cp $PG $HA_DIR/
			tlog "chmod 774 ${HA_DIR}/${PG}" $LOG
			chmod 774 ${HA_DIR}/${PG}
		else
			tlog "Please to check the $PG" $LOG
		fi
	done

	#Moni IB script Program
	for PG in ${IB_MONI[@]}
	do
		if [[ -f $PG ]];then
			tlog "cp $PG $IB_DIR" $LOG
			cp $PG $IB_MONI_DIR
			tlog "chown $EXADM_OWN ${IB_MONI_DIR}/${PG}" $LOG
			chown $EXADM_OWN ${IB_MONI_DIR}/${PG}
			tlog "chmod 775 ${IB_MONI_DIR}/${PG}" $LOG
			chmod 775 ${IB_MONI_DIR}/${PG}
		else
			tlog "Please to check the $PG" $LOG
		fi
	done
}
#}}}

#{{{main
main () {

	tlog "***************************InfiniBand program instll start************************************" $LOG
	# check execute user is twse
	user_check
	exec_status=$?
	if [[ $exec_status -eq "0" ]];then	
		# mkdir the InfiniBand script DIR
		mk_dir
		# install program 
		install
	else
		tlog "[ERR] $USER permission denied, than $0 script terminated" $LOG
		exit 1
	fi

	exit 0
}
#}}}

main
