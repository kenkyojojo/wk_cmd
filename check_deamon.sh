#!/usr/bin/ksh
#
############################################################
DEAMON=deamon.list
LOG=$0.log
DT=`date +"%y/%m/%d %H:%M:%S"`
TODEM=`cat $DEAMON | wc -l`
############################################################
echo "########################################################" >> $LOG
echo "Check Start Time $DT" >> $LOG

print_log (){

	if [[ $STATE -eq 0 ]];then
		echo "$DEMON service running" >> $LOG
	else 
		echo "$DEMON service not running" >> $LOG
	fi
}

check_demon (){
echo "########################################################"
echo "Check Time $DT"
SUCCESS=0
ERROR=0
for DEMON in `cat deamon.list`
do
	ps -ef | grep -v grep | grep -q $DEMON
	if [[ $? -eq 0 ]];then
		echo "$DEMON service running"
		STATE=0
		SUCCESS=$(( $SUCCESS + 1 ))
	else 
		echo "$DEMON service not running"
		STATE=1
		ERROR=$(( $ERROR + 1 ))
	fi
print_log
done
echo "Total Deamon Check Service:$TODEM, Running:$SUCCESS, Not_running:$ERROR"
echo "Total Deamon Check Service:$TODEM, Running:$SUCCESS, Not_running:$ERROR" >> $LOG
}
check_demon
