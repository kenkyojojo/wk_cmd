#!/usr/bin/ksh 
#Location:Jin-AI
#
HMC=10.199.168.171
SYSTEM=`lssyscfg -r sys -F name |grep 9179`

#Running Resource selector type use "hvlpconfigdata -affinity -domain"
To_ssh () {
		
		ssh  hscroot@${HMC} "/usr/hmcrbin/startdump -t resource -m $SYSTEM -r "hvlpconfigdata -affinity -domain" "
		clear
		STATE=$?
	 	if [[ $STATE -ne 0 ]]; then
		 	echo "To running resource dump Failed."
		 	exit 1
	    fi
}

#Use scp to download Resource dump file form HMC.
To_scp () {
		RESOURCEFILE=`lsdump -h --filter "dump_type=resource" -F name | tail -1`
		FILECOUNT=`echo $RESOURCEFILE | grep -c 'RSCDUMP'`

		if [[ $FILECOUNT -ne 1]];then
			echo "No resource dump file in /dump directory on HMC=$HMC"
			echo "Please to check resource dump file in /dump directory on HMC server"
		fi

		scp hscroot@${HMC}:/dump/${RESOURCEFILE} /home/padmin/RSDUMP/
		STATE=$?
	 	if [[ $STATE -eq 0 ]]; then
		 	echo "Use scp to download resource dump Success."
		 	echo "Download file store in /home/padmin/RESDUMP/"
		 	exit 0
	 	else
		 	echo "To running resource dump Failed."
		 	exit 1
		fi
}

main () {
		To_ssh
		To_scp
}

main

