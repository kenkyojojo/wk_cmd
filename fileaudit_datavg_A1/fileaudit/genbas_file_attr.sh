#!/bin/ksh
#
#----------------------------------
# Set variable
#----------------------------------
hostname=`hostname`
HOSTN=$(echo $hostname | cut -c 1-3)
CONFIGDIR=/tmp/fileaudit/cfg
SHDIR=/tmp/fileaudit
case $HOSTN in
	*)
		DIR=`head -1 $CONFIGDIR/dir.conf`
		EXIST=`sed -n '2p' $CONFIGDIR/dir.conf`
		DIRNOTIME=`sed -n '3p' $CONFIGDIR/dir.conf`
		NOCHECK=`sed -n '2p' $CONFIGDIR/dir.conf;sed -n '3p' $CONFIGDIR/dir.conf;sed -n '4p' $CONFIGDIR/dir.conf`
		EXCLUDE=`tail -1 $CONFIGDIR/dir.conf | sed -e 's#\/#\\\/#g' -e 's/ /\/d\" -e \"\//g' -e 's/^/sed -e "\//' -e 's/$/\/d"/'`
		;;
esac

ALLEXCLUDE=`echo $NOCHECK | sed -e 's#\/#\\\/#g' -e 's/ /\/d\" -e \"\//g' -e 's/^/sed -e "\//' -e 's/$/\/d"/'`

FILEDIR=${SHDIR}

BASEFILE=$FILEDIR/base/${hostname}_file_attr.bas
EXISTBASE=$FILEDIR/base/${hostname}_file_exist.bas
BACKUP_BASE=$FILEDIR/base/${hostname}_previous_file_attr.bas
BACKUP_EXISTBASE=$FILEDIR/base/${hostname}_previous_file_exist.bas
#----------------------------------
#Create the fileaudit base file. 
#----------------------------------

creat_base(){
#set -x 
for DIRNAME in $DIR #import all dir_list from prompt
do
   #${SHDIR}/sefind $DIRNAME -ls 2>/dev/null | eval $ALLEXCLUDE | sort -k2  >> $BASEFILE #generate CURRENT status to compare with BASEFILE
	#find $DIRNAME -exec ls -cdils {} \; >> $BASEFILE 2>/dev/null
	find $DIRNAME 2>/dev/null |xargs ls -lisd  >> $BASEFILE 2>/dev/null
#find $DIRNAME -ls  >> $BASEFILE 2>/dev/null
#find $DIRNAME | xargs sum >> ${BASEFILE}.sum
done
cat $BASEFILE | eval $ALLEXCLUDE > ${BASEFILE}.tmp #generate CURRENT status to compare with BASEFILE
mv ${BASEFILE}.tmp ${BASEFILE}
sort -k 11 ${BASEFILE} -o ${BASEFILE}
}


creat_existbase(){
for DIRNAME in $EXIST #import all dir_list from prompt
do
	#${SHDIR}/sels -ld $DIRNAME  2>/dev/null | eval $EXCLUDE |awk '{print $3,$4,$1,$9}' >> $EXISTBASE
    ls  -ld $DIRNAME  2>/dev/null | eval $EXCLUDE |awk '{print $3,$4,$1,$9}' >> $EXISTBASE
done

for DIRNAME in $DIRNOTIME #Recursive list dir, but don't list the file and directory time. 
do
	#${SHDIR}/sefind $DIRNAME -ls 2>/dev/null | eval $EXCLUDE | awk '{print $5,$6,$3,$NF}'  >> $EXISTBASE
	find $DIRNAME ! -type l -ls 2>/dev/null | eval $EXCLUDE | awk '{print $7,$5,$6,$3,$NF}'  >> $EXISTBASE
done
}


echo Generating the Basefile for auditing
echo ---------------------------------------------------------------
echo IMPORTANT NOTES:
if [ -f $BASEFILE ] || [ -f $EXISTBASE ]; then
	echo Basefile \"$BASEFILE\" or  \"$EXISTBASE\" already existed

		if [ -f $BASEFILE ]; then
			echo create at \"`ls -l $BASEFILE | awk '{print $6,$7,$8,"and owner/group is",$3"/"$4}'`\"
			mv $BASEFILE $BACKUP_BASE
			creat_base
			echo "Overwrite basefile $BASEFILE with CURRENT status, Total `awk 'END {print NR}' $BASEFILE` lines"
			echo "Old basefile backup to \"$BACKUP_BASE\", Total `awk 'END {print NR}' $BACKUP_BASE` lines"
		fi

		if [ -f $EXISTBASE ]; then
			echo create at \"`ls -l $EXISTBASE| awk '{print $6,$7,$8,"and owner/group is",$3"/"$4}'`\"
			mv $EXISTBASE $BACKUP_EXISTBASE
			creat_existbase
			echo "Overwrite basefile $EXISTBASE with CURRENT status, Total `awk 'END {print NR}' $EXISTBASE` lines"
			echo "Old basefile backup to \"$BACKUP_EXISTBASE\", Total `awk 'END {print NR}' $BACKUP_EXISTBASE` lines"
		fi
	echo

	exit 0
else
#	echo "Creating basefile $BASEFILE and writing the current status in it."
	echo "Creating basefile $EXISTBASE and writing the current status in it."
#	creat_base $DIR
#	creat_existbase $EXIST $DIRNOTIME
#	creat_base
	creat_existbase
	exit 0
fi

exit
