#!/bin/ksh
USER="twse"
set -A FIX FIXGW01P FIXGW01B FIXGW02P FIXGW02B
FIX1P=FIXGW01P
FIX1B=FIXGW01B
FIX2P=FIXGW02P
FIX2B=FIXGW02B
#WKLA=X230
WKLA=WKLPARA1
PORT=2222
WKLB=WKLPARB1
HOSTNAME=`hostname`
Homedir=`lsuser -a home $USER | awk -F '=' '{print $2}'`
TMPDIR=/tmp/ssh_auth_dir
LOG=/tmp/ssh_key.log

#{{{tlog
tlog() {
	MSG=$1
	LOG=$2
	dt=`date +"%y/%m/%d %H:%M:%S"`
	echo "$SITE [${dt}] $MSG" | tee  -a $LOG
}        
#}}}

#{{{scp_file 
scp_file (){

tlog "mkdir $TMPDIR" $LOG
mkdir $TMPDIR

	for LPAR in ${FIX[@]}
	do
		tlog "mkdir $TMPDIR/$LPAR" $LOG
		mkdir $TMPDIR/$LPAR
		tlog "scp -P $PORT $LPAR:${Homedir}/.ssh/id_rsa.pub  $LPAR:${Homedir}/.ssh/authorized_keys ${TMPDIR}/$LPAR" $LOG
		scp -P $PORT $LPAR:${Homedir}/.ssh/id_rsa.pub  $LPAR:${Homedir}/.ssh/authorized_keys ${TMPDIR}/$LPAR
	done
}
#}}}

#{{{fixgw01p
fixgw01p(){
	for LPAR in  $FIX1B $FIX2P $FIX2B $FIX1P
	do
		tlog "cat ${TMPDIR}/${LPAR}/id_rsa.pub >> ${TMPDIR}/${FIX1P}/authorized_keys" $LOG
		cat ${TMPDIR}/${LPAR}/id_rsa.pub >> ${TMPDIR}/${FIX1P}/authorized_keys
	done
}
#}}}

#{{{fixgw01b
fixgw01b(){
	for LPAR in $FIX1P $FIX2B $FIX2P $FIX1B
	do
		tlog "cat ${TMPDIR}/${LPAR}/id_rsa.pub >> ${TMPDIR}/${FIX1B}/authorized_keys" $LOG
		cat ${TMPDIR}/${LPAR}/id_rsa.pub >> ${TMPDIR}/${FIX1B}/authorized_keys
	done
}
#}}}

#{{{fixgw02p
fixgw02p(){
	for LPAR in  $FIX2B $FIX1B $FIX1P
	do
		tlog "cat ${TMPDIR}/${LPAR}/id_rsa.pub >> ${TMPDIR}/${FIX2P}/authorized_keys" $LOG
		cat ${TMPDIR}/${LPAR}/id_rsa.pub >> ${TMPDIR}/${FIX2P}/authorized_keys
	done
}
#}}}

#{{{fixgw02b
fixgw02b(){
	for LPAR in  $FIX2P $FIX1B $FIX1P 
	do
		tlog "cat ${TMPDIR}/${LPAR}/id_rsa.pub >> ${TMPDIR}/${FIX2B}/authorized_keys" $LOG
		cat ${TMPDIR}/${LPAR}/id_rsa.pub >> ${TMPDIR}/${FIX2B}/authorized_keys
	done
}
#}}}

#{{{trans_file
trans_file (){

	for LPAR in ${FIX[@]}
	do
		tlog "scp -P $PORT ${TMPDIR}/$LPAR/authorized_keys $LPAR:${Homedir}/.ssh/authorized_keys" $LOG
		scp -P $PORT ${TMPDIR}/$LPAR/authorized_keys $LPAR:${Homedir}/.ssh/authorized_keys
	done
}
#}}}}

#{{{fixgw01p_check
fixgw01p_check(){
	for LPAR in  $FIX1B $FIX2P $FIX2B $FIX1P
	do
		CHKLPAR=$(su - $USER -c ssh -p $PORT -o BatchMode=yes $FIX1P ssh -p $PORT -o BatchMode=yes $LPAR hostname)
		if [[ $CHKLPAR = $LPAR ]];then
			tlog "$FIX1P ssh_key exchange to $CHKLPAR  success"
		else
			tlog "$FIX1P ssh_key exchange to $CHKLPAR  failed"
		fi
	done
}
#}}}

#{{{fixgw01p_check
fixgw01b_check(){
	for LPAR in $FIX1P $FIX2B $FIX2P $FIX1B
	do
		CHKLPAR=$(su - $USER -c ssh -p $PORT -o BatchMode=yes $FIX1B ssh -p $PORT -o BatchMode=yes $LPAR hostname)
		if [[ $CHKLPAR = $LPAR ]];then
			tlog "$FIX1B ssh_key exchange to $CHKLPAR  success"
		else
			tlog "$FIX1B ssh_key exchange to $CHKLPAR  failed"
		fi
	done
}
#}}}

#{{{fixgw02p_check
fixgw02p_check(){
	for LPAR in  $FIX2B $FIX1B $FIX1P
	do
		CHKLPAR=$(su - $USER -c ssh -p $PORT -o BatchMode=yes $FIX2P ssh -p $PORT -o BatchMode=yes $LPAR hostname)
		if [[ $CHKLPAR = $LPAR ]];then
			tlog "$FIX2P ssh_key exchange to $CHKLPAR  success"
		else
			tlog "$FIX2P ssh_key exchange to $CHKLPAR  failed"
		fi
	done
}
#}}}

#{{{fixgw02b_check
fixgw02b_check(){
	for LPAR in  $FIX2P $FIX1B $FIX1P 
	do
		CHKLPAR=$(su - $USER -c ssh -p $PORT -o BatchMode=yes $FIX2B ssh -p $PORT -o BatchMode=yes $LPAR hostname)
		if [[ $CHKLPAR = $LPAR ]];then
			tlog "$FIX2B ssh_key exchange to $CHKLPAR  success"
		else
			tlog "$FIX2B ssh_key exchange to $CHKLPAR  failed"
		fi
	done
}
#}}}

#{{{clean_tmp 
clean_tmp (){
	tlog "rm -rf ${TMPDIR}" $LOG
	rm -rf ${TMPDIR}
}
#}}}

#{{{main 
main () {
	if [[ $HOSTNAME = "$WKLA" ]] || [[ $HOSTNAME = "$WKLB" ]]; then
		scp_file
		echo "#==========#" |tee -a $LOG
		fixgw01p
		echo "#==========#" |tee -a $LOG
		fixgw01b
		echo "#==========#" |tee -a $LOG
		fixgw02p
		echo "#==========#" |tee -a $LOG
		fixgw02b
		echo "#==========#" |tee -a $LOG
		trans_file
		echo "#==========#" |tee -a $LOG
		fixgw01p_check
		echo "#==========#" |tee -a $LOG
		fixgw01b_check
		echo "#==========#" |tee -a $LOG
		fixgw02p_check
		echo "#==========#" |tee -a $LOG
		fixgw02b_check
		echo "#==========#" |tee -a $LOG
		clean_tmp
	else
		tlog "Please to check LPAR is WKLPAR" $LOG
		exit 1
	fi
}
#}}}

main
