#!/usr/bin/ksh 
#Location:Jin-AI
#
HMC=192.168.100.150
SYSTEM=`lssyscfg -r sys -F name |tail -1`

#Running Resource selector type use "hvlpconfigdata -affinity -domain"
start_resource_dump () {
		
		clear

		startdump -t resource -m $SYSTEM -r 'hvlpconfigdata -affinity -domain' 

		RESOURCEFILE=`lsdump -h --filter "dump_type=resource" -F name | tail -1`
		exit $RESOURCEFILE
		FILECOUNT=`echo $RESOURCEFILE | grep -c 'RSCDUMP'`
		if [[ $FILECOUNT -ne 1 ]];then
			echo "No resource dump file in /dump directory on HMC=$HMC"
			echo "Please to check resource dump file in /dump directory on HMC server"
			exit 1
		fi

}

#Use scp to download Resource dump file form HMC.
download_resource_dump () {

		RESOURCEFILE=`lsdump -h --filter "dump_type=resource" -F name | tail -1`
		FILECOUNT=`echo $RESOURCEFILE | grep -c 'RSCDUMP'`

		if [[ $FILECOUNT -ne 1 ]];then
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
	start_resource_dump $RESOURCEFILE		


	#RESOURCEFILE=`lsdump -h --filter "dump_type=resource" -F name | tail -1`
 	#./resource_dump.Menu.sh $RESOURCEFILE
#	download_resource_dump
}

main
