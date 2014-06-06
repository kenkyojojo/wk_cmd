#!/usr/bin/ksh
SHELL=/home/se/safechk/safesh
LOG=/home/se/safechk/safelog
DT=`date +"%y/%m/%d %H:%M:%S"`
HOSTNAME=`hostname`

$SHELL/syschk_base_current.sh > $LOG/syschk.`hostname`.now
diff $LOG/syschk.${HOSTNAME}.base $LOG/syschk.${HOSTNAME}.now > $LOG/syschk.diff

echo "########################################################" >> $LOG/syschk_diff.${HOSTNAME}.log
echo "Start Time $DT" >> $LOG/syschk_diff.${HOSTNAME}.log

if [[ -s $LOG/syschk.diff  ]];then
	echo "$HOSTNAME  Error" >> $LOG/syschk_diff.${HOSTNAME}.log
	echo "$HOSTNAME  Please to check the file $LOG/syschk.diff" >> $LOG/syschk_diff.${HOSTNAME}.log
else
	echo "$HOSTNAME  OK." >> $LOG/syschk_diff.${HOSTNAME}.log
fi
