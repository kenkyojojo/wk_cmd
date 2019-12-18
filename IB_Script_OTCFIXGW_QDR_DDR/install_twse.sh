#!/usr/bin/ksh
IB_DIR="/TWSE/bin/TWSE/HA_script"
IB_LOG="/TWSE/IB_log"
IB_CFG="/TWSE/cfg/TWSE/HA_script"
#IB_MONI_DIR="/tmp/ib_script_moniter"
#IB_MONI_DIR_RS="${IB_MONI_DIR}/release"
IB_MONI_DIR="/TWSE/bin"
HA_DIR="/home"
TWSE_OWN="twse:tse"
EXADM_OWN="exadm:exc"
IB_SHELL="ib_start.sout ib_stop.sout switch_ha.sout"
HA_SHELL="startAP.sh stopAP.sh twse_rbac.sh initial_ib_ip.sh"
IB_MONI="ibsmon_np_client ibsmon_np"
IB_CFG_FILE="ib_start.cfg ib_stop.cfg switch_ha.cfg"
#                       1        2           3
#set -A TWSE_DIR_LIST $IB_DIR $IB_MONI_DIR $IB_MONI_DIR_RS $HA_DIR
set -A TWSE_DIR_LIST $IB_DIR $IB_MONI_DIR $HA_DIR $IB_LOG
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
			tlog "The $DIR dir is already exist" $LOG
		fi
	done
	# For twse user can write log 
	tlog "chmod 777 $IB_LOG " $LOG
	chmod 777 $IB_LOG 
}
#}}}

#{{{install
install () {
	#IB script config
	for PG in ${IB_CFG_FILE[@]}
	do
		if [[ -f $PG ]];then
			tlog "cp $PG $IB_CFG" $LOG
			cp $PG $IB_CFG
			tlog "chown $EXADM_OWN ${IB_CFG}/${PG}" $LOG
			chown $EXADM_OWN ${IB_CFG}/${PG}
			tlog "chmod 664 ${IB_CFG}/${PG}" $LOG
			chmod 664 ${IB_CFG}/${PG}
		else
			tlog "Please to check the $PG" $LOG
		fi
	done

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
			if [[ $PG = "initial_ib_ip.sh" ]];then
				tlog "cp $PG $HA_DIR" $LOG
				cp $PG $HA_DIR/
				tlog "chmod 750 ${HA_DIR}/${PG}" $LOG
				chmod 750 ${HA_DIR}/${PG}
				continue
			fi
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
			tlog "cp $PG $IB_MONI_DIR" $LOG
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
