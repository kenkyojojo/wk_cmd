#!/usr/bin/ksh 
#Location:Jin-AI
#
HMC=192.168.100.150

To_ssh () {
	#echo "ssh -T hscroot@${HMC} < resource_dump_rcmd.sh "
	echo "ssh -T hscroot@${HMC} < $1"
}

#Use scp to download Resource dump file form HMC.
download_resource_dump () {
                RESOURCEFILE=`ssh -T hscroot@{HMC} lsdump -h --filter "dump_type=resource" -F name | tail -1`
                FILECOUNT=`echo $RESOURCEFILE | grep -c 'RSCDUMP'`

                if [[ $FILECOUNT -ne 1 ]];then
                        echo "No resource dump file in /dump directory on HMC=$HMC"
                        echo "Please to check resource dump file in /dump directory on HMC server"
                fi

                echo "scp hscroot@${HMC}:/dump/${RESOURCEFILE} /home/padmin/RSDUMP/"
                scp hscroot@${HMC}:/dump/${RESOURCEFILE} /home/padmin/RSDUMP/
#                STATE=$?
#                if [[ $STATE -eq 0 ]]; then
#                        echo "Use scp to download resource dump Success."
#                        echo "Download file store in /home/padmin/RESDUMP/"
#                        exit 0
#                else
#                        echo "To running resource dump Failed."
#                        exit 1
#                fi
}

main () {
	To_ssh 
#	download_resource_dump
}
main resource_dump_rcmd.sh
