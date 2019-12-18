#!/usr/bin/ksh
DATEY=`date +'%Y'`
DATEM=`date +'%m'`
HOSTNAME=`hostname`
LOG="/tmp/job.sh.log"
YEARBKDIR="/bk_year"
MONTHBKDIR="/bk_month"

echo "#===========${DATEY}${DATEM}===============#" | tee -a $LOG

if [[ -d $YEARBKDIR ]] && [[ -d $MONTHBKDIR ]] ;then
	if [[ $DATEM -eq "01" ]]; then
	# if the month is 1 than backup to year directory,else backup to month directory.
		echo "Delete last year mksysb backup" | tee -a $LOG
			 rm -f ${YEARBKDIR}/${HOSTNAME}.mksysb
		echo "Finish delete last year mksysb backup" | tee -a $LOG

		echo "Start year mksysb backup" | tee -a $LOG
			 mksysb -i ${YEARBKDIR}/${HOSTNAME}.mksysb
		echo "Finish year mksysb backup" | tee -a $LOG
	else
		echo "Delete last month mksysb backup" | tee -a $LOG
			 rm -f ${MONTHBKDIR}/${HOSTNAME}.mksysb
		echo "Finish delete last month mksysb backup" | tee -a $LOG

		echo "Start month mksysb backup" | tee -a $LOG
			 mksysb -i ${MONTHBKDIR}/${HOSTNAME}.mksysb
		echo "Finish month mksysb backup" | tee -a $LOG
	fi
else
		echo "Please to check the year backup directory and month directory" | tee -a $LOG
fi
