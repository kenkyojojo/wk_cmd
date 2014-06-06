#!/usr/bin/ksh
set -n 
syserrdate=`date +"%m/%d"`
errcount=0
STATUS=
HOSTS=`hostname`
SCRIPT=`basename $0`
REPORT="/tmp/report.txt"

#FS percent
FILESYSTEM_CHECK() {
echo "****************************ACTIVE VG****************************\n"
FS=`df -k|sed '1d'|awk 'sub("%","",$4) {if ($4 > 80) print $7}'|xargs`
for i in $FS
do
	echo "The $i filesystem percent more than %80 \n"
done
}

#Active VG
VG_CHECK() {
echo "****************************ACTIVE VG****************************\n"
ACVG=`lsvg -o|xargs`
echo "Active VG is: $ACVG\n"
#LV_CHECK 
echo "***************************PROBLEM LV****************************\n"
BLV=`lsvg -l rootvg|grep -E "jfs|jfs2|raw"|grep -v 'N/A'|awk '{if ($6~/closed/ || $6~/stale/) print $1}'|xargs`
for i in $BLV
do
	echo "The $i filesystem has a problem!!!\n"
done
}

#Problem disk
DISK_CHECK() {
echo "***************************Problem disk***************************\n"
disk=`lsvg -o|lsvg -ip|awk '$1~/hdisk/ && $2!~/active/ {print $1}'|xargs`
if [ "$disk" != "" ]
then
for i in $disk
do
	echo "The $disk in $i has a problem!!!\n"
done
fi
}

#error report
ERROR_CHECK() { 
echo "***************************error report***************************\n"
errdate=`errpt |grep -v IDENTIFIER |awk '{print $2}' |cut -c 1-4 |xargs`
for syserrFor1 in $errdate
do
	if [ "$syserrFor1" = "$syserrdate" ]
	then
		newerrcount=`expr $errcount + 1`
		errcount=$newerrcount
	fi
done
if [ "$errcount" -eq 0 ]
then
	echo "Today error is add $errcount yesterday\n"
else
	echo "Today errors is add $errcount than yesterday\n"
fi

#error detail
rrors=`errpt -dH -TPERM`
if [ -z "$errors" ]
then
	echo "The Hardware is ${STATUS:-NORMAL}.\n"
else
	echo "The permanent error of Hardware as fllow:\n`errpt -dH -TPERM`"
fi
}

#Check Database
DB_CHECK() {
su - oracle -c "lsnrctl status"|grep -i "no listener"
if [ $? = 1 ]
then
	echo "The listener status is ${STATUS:-NORMAL}\n"
else
	echo "The listener has a problem!!!\n"
fi
#echo "The listener status is :`su - oracle -c \"lsnrctl status\"\`\n"
#echo "Database status is:"
#su - oracle -c "sqlplus -s /nolog"<<EOF|sed '/^$/d'
#conn /as sysdba
#select log_mode,name,open_mode from v\$database;
#quit
#EOF
su - oracle -c "sqlplus -s /nolog"<<EOF|sed '/^$/d' 2>/dev/null|grep -i "ORACLE not available"
conn /as sysdba
select log_mode,name,open_mode from v\$database;
quit
EOF
if [ $? = 0 ]
then
	echo "The database not available!!!\n"
else
	echo "The database is NORMAL\n"
fi
}

#HBA card link
HARDWARE_CHECK() { 
fget_config -Av|grep -i dacnone>>/dev/null
if [ $? -eq 0 ]
then
	echo "The storage link has problem!!!"
else
	echo "The storage link NORMAL!"
fi
}

#HACMP CHECK
HA_CHECK() {
	echo "The HACMP status is: `lssrc -g cluster|sed '1d'`"
}

#CHECK SNA
SNA_CHECK() {
	echo "The SNA LINK STATUS is:`sna -d l`"
	echo "The SNA SESSION has problem as fllows:\n"
	sna -d sl|tail +4|awk 'BEGIN { FS="\t"; print "name","\tactsess","actconw"}{if ($7 == 0 && $8 == 0) print $1, $7,$8}'
}

#CHECK CICS
CICS_CHECK() {
	echo "The not active CICS is as fllows:\n"
	lssrc -a|grep cics|awk '$3!~/active/ {print $1}'
}

echo $SCRIPT. >$REPORT
echo $HOSTS >> $REPORT
echo "IP ADDRESS:`ifconfig -a|grep -w inet|grep -v 127.0.0.1|awk '{print $2}'`" >> $REPORT
netstat -v|grep -E "STAT|Link" >>$REPORT
oslevel >> $REPORT

FILESYSTEM_CHECK >>$REPORT 2>&1
VG_CHECK >>$REPORT 2>&1
DISK_CHECK >>$REPORT 2>&1
ERROR_CHECK >>$REPORT 2>&1
DB_CHECK >>$REPORT 2>&1
HARDWARE_CHECK >>$REPORT 2>&1

lslpp -L|grep cluster >/dev/null
if [ $? -eq 0 ]
then
HA_CHECK >>$REPORT 2>&1
else
echo "This machine not install HACMP" >> $REPORT
fi

lslpp -L|grep "sna.rte" >/dev/null
if [ $? -eq 0 ]
then
SNA_CHECK >>$REPORT 2>&1
else
echo "This machine not install sna" >> $REPORT
fi

lslpp -L|grep -i cics >/dev/null
if [ $? -eq 0 ]
then
CICS_CHECK >>$REPORT 2>&1
else
echo "This machine not install cics" >> $REPORT
fi

