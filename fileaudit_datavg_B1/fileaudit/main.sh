#!/bin/ksh
#
if [[ -n $1 ]] then
	hostname=`echo $1 | tr [:lower:] [:upper:]`
else
	hostname=`hostname`
fi

FILE=/tmp/fileaudit
FILESH=$FILE
FILELOG=${FILE}/safelog

$FILESH/filecheck.sh $hostname > $FILELOG/safelog.${hostname}.fileattr.`date +%Y%m%d` 2> $FILE/err/safelog.${hostname}.fileattr.`date +%Y%m%d.err`
#chown useradm:security $FILELOG/safelog.${hostname}.fileattr.`date +%Y%m%d`
cat $FILELOG/safelog.${hostname}.fileattr.`date +%Y%m%d`

exit
