#/usr/bin/ksh
LOG="/tmp/ibstatus"
SITE="TSEOT2"
INTERVAL="2"

#{{{tlog ,script loger function
tlog() {
set -x 

    MSG=$1
    LOG=$2
	dt=`date +"%y/%m/%d %H:%M:%S"`

	print "$SITE [${dt}]" | tee  -a $LOG
	print "$MSG" | tee  -a $LOG
}
#}}}

#{{{main 
main () {
#set -x 

while  true 
do
	clear
	#tlog "$(ls -l /tmp;df -h)" $LOG
	tlog "$(lsattr -El ib0 | grep -E 'ib_adapter|ib_port';ibstat)"  $LOG
	print "*******************************************************************************************" | tee -a  $LOG
	print "\n" | tee -a $LOG
	sleep ${INTERVAL}
done
}
#}}}

main
