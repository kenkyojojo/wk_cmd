#!/bin/ksh
#For this script to work properly you need to take a snapshot of the directory
#you want to monitor and pipe the result to "BASEFILE".
#You can also enter the directory you would like to monitor by typing it after
#the command to run the script and hit enter example : ./script_name Directory_to_Monitor
#If you dont want to enter a directory to monitor at the command-line you can
#also enter the directory to monitor in the script at the "DIR" line.

#author : Stev.Hsu TWSE
#date	: 2014.12.23
#version: beta 1.0
#add function: multiple dir_list parameters input from commandline - 2012.02.27
#add function: use symbol '^' to mark MODIFIED attribute - 2012.03.03
#add function: add dir.conf to set the searching and exclude folder - 2012.03.08
#add function: use EXCLUDE attribute to bypass special file or folder - 2012.03.13
#fix bug: On AIX OS every 6 month disply the time will from time indent to year - 2014.12.23


#----------------------------------
# Set variable
#----------------------------------
if [[ -n $1 ]];then
	hostname=`echo $1 | tr [:lower:] [:upper:]`
else
	hostname=`hostname`
fi

SHELL=filecheck.sh
SHDIR=/tmp/fileaudit
SITE="TSEOA compare TSEOB"
CONFIGDIR=${SHDIR}/cfg
FILEDIR=$SHDIR
LOGDIR=${FILEDIR}/safelog
DATEM=`date +%Y%m`
LOG=$LOGDIR/${DATEM}.${hostname}.${SHELL}.log
HOSTN=$(echo $hostname | cut -c 1-3)

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
EXCLUDE_EXIST=`echo $EXIST | sed -e 's#\/#\\\/#g' -e 's/ /\$\/d\" -e \"\//g' -e 's/^/sed -e "\//' -e 's/$/\/d"/'`


BASEFILE=$FILEDIR/base/${hostname}_file_attr.bas
EXISTBASE=$FILEDIR/base/${hostname}_file_exist.bas
CURRENT=$FILEDIR/check/${hostname}_`date +%Y%m%d_file_attr.chk`
CURRENT_EXIST=$FILEDIR/check/${hostname}_`date +%Y%m%d_file_exist.chk`
RESULT=$FILEDIR/result/${hostname}_`date +%Y%m%d_file_attr.rst`
RESULT_EXIST=$FILEDIR/result/${hostname}_`date +%Y%m%d_file_exist.rst`
FILECHG=$LOGDIR/${hostname}_`date +%Y%m%d_file_attr.chg`
FILECHG_EXIST=$LOGDIR/${hostname}_`date +%Y%m%d_file_exist.chg`
CHKDIR=/home/se/chk/fileaudit
debugmod="1"		# for debug! (1=on , 0=off)

#----------------------------------
# Temp file for compare and debug
#----------------------------------
CURRENT_MODI=$FILEDIR/${hostname}_`date +%Y%m%d_modified_file_attr.chk`
TMP_CUR=$FILEDIR/tmp_current
TMP_CUR_MODI=$FILEDIR/tmp_current_modi
TMP_BASE=$FILEDIR/tmp_base
TMP_CHANGE=$FILEDIR/tmp_change
TMP_CHANGETWO=$FILEDIR/tmp_changetwo
TMP_CHANGETRE=$FILEDIR/tmp_changetre
TMP_DEBUG=$FILEDIR/DEBUG
LIST_ADD=$FILEDIR/file_add
LIST_DEL=$FILEDIR/file_del
LIST_CHANGE=$FILEDIR/file_change

TMP_EXISTCUR=$FILEDIR/tmp_exist_current
TMP_EXISTBASE=$FILEDIR/tmp_exist_base
TMP_EXISTCHANGE=$FILEDIR/tmp_exist_change
LIST_EXISTADD=$FILEDIR/file_exist_add
LIST_EXISTDEL=$FILEDIR/file_exist_del
LIST_EXISTCHANGE=$FILEDIR/file_exist_change

echo "#============================================================#" >> $LOG

#{{{tlog
#-----------------------
# Show running step status
#-----------------------
tlog() {
    msg=$1
	if [ "$debugmod" = "1" ]; then
		dt=`date +"%y/%m/%d %H:%M:%S"`
		echo "DATE: [${dt}] $msg" >> $LOG
	fi
}
#}}}

#{{{check_base_file
#----------------------------------
# To check the  base files exists
#----------------------------------
check_base_file(){
tlog "Running check_base_file start"
BASE_FILE=`grep 'exists' $CHKDIR/fileaudit.status|wc -l`
	cat /dev/null > $CHKDIR/fileaudit.status

	if [ ! -f $BASEFILE ];then 
		echo "Failed:The $BASEFILE file is not exists" 
		echo "Failed:The $BASEFILE file is not exists" >> $CHKDIR/fileaudit.status
	fi
	if [ ! -f $EXISTBASE ];then 
		echo "Failed:The $EXISTBASE file is not exists"
		echo "Failed:The $EXISTBASE file is not exists" >> $CHKDIR/fileaudit.status 
	fi

	if  [ "$BASE_FILE" -ge 1 ] ;then
		exit
	fi
tlog "Running check_base_file end"
}
#}}}

#{{{clear_tmp
#----------------------------------
# Clear temporary files
#----------------------------------
clear_tmp(){
tlog "Running clear_tmp start"
	set -A TMP_FILE $TMP_BASE $TMP_CUR $TMP_CHANGE $TMP_EXISTBASE $TMP_EXISTCUR $TMP_EXISTCHANGE $TMP_DEBUG $TMP_CHANGETWO $LIST_ADD $LIST_DEL $LIST_CHANGE $LIST_EXISTADD $LIST_EXISTDE $LIST_EXISTCHANGE $TMP_CUR_MODI $LIST_EXISTDEL $FILECHG_EXIST $FILECHG

   for TMP_FILE in ${TMP_FILE[@]}
   do
  	 rm -f $TMP_FILE 2>/dev/null
   done
tlog "Running clear_tmp end"
}
#}}}

#{{{seperater
#----------------------------------
# If item were different then show the '^' symbol below it
#----------------------------------
seperater() {
let x=0
while((x<$1))
do
    print -n "$2"
	let x+=1
done
print -n " "
}
#}}}

#{{{daily_check_status
#----------------------------------
# check_status 
# 1.echo "OK" or "failed" to $CHKDIR/fileaudit.status for the /home/se/chk/'s dailycheck.
# 2.if the fileaudit.status no file has modified, then cp the current attr.bas over write the original attr.bas .
# 3.為seadm日檢核所產生確認檔
#----------------------------------
daily_check_status(){
RESULT=`grep 'Failed' $RESULT|wc -l`
RESULT_EXIST=`grep 'Failed' $RESULT_EXIST|wc -l`
tlog "Running daily_check_status start"

cat /dev/null > $CHKDIR/fileaudit.status

if  [ "$RESULT_EXIST" -ge 1 ] ;then
	echo "Check_exist Failed" >> $CHKDIR/fileaudit.status
else
	echo "Check_exist OK" >>  $CHKDIR/fileaudit.status
fi

if [ "$RESULT" -ge 1 ] ;then
	echo "Check_modified Failed" >> $CHKDIR/fileaudit.status
else
	tlog "Current attr.bas has over write the original attr.bas"
	echo "Check_modified OK" >> $CHKDIR/fileaudit.status
	cp $CURRENT $BASEFILE
fi
 
tlog "Running daily_check_status end"
}
#}}}

#{{{check_exist
#----------------------------------
# Check File or Directory exist
# 不檢查檔案時間屬性
#----------------------------------
check_exist(){
#set -x 

tlog "Running check_exist start"
echo 
echo "#============================================================#"
echo "# The SITE:$SITE"
echo "# The Hostname:$hostname"
echo "# 檢查檔案及目錄(無時間屬性)"
echo "# 共檢查 `awk 'END {print NR}' $EXISTBASE` 檔案"
echo "# Date: `date +%Y/%m/%d\ %H:%M`"
echo "#============================================================#"
#cat /dev/null > $RESULT_EXIST #flush the check_status_file

if [ -f $EXISTBASE ]; then
   cat /dev/null > $CURRENT_EXIST
#   for DIRNAME in $EXIST
#   do
#		ls -ld  $DIRNAME  2>/dev/null | eval $EXCLUDE |awk '{print $3,$4,$1,$9}'  >> $CURRENT_EXIST 
		#${SHDIR}/sels -ld $DIRNAME  2>/dev/null | eval $EXCLUDE |awk '{print $3,$4,$1,$9}'  >> $CURRENT_EXIST 
#   done

   for DIRNAME in $DIRNOTIME #Recursive list dir, but don't list the file and directory time.
   do
		find $DIRNAME ! -type l -ls 2>/dev/null | eval $EXCLUDE | awk '{print $7,$5,$6,$3,$NF}'  >> $CURRENT_EXIST
   done

   awk '{if ($4~/\/dev\// || $NF~/\/dev\//) if ($1~/c/ || $1~/b/) {print $NF} else {print $NF} else {print $NF}}' $CURRENT_EXIST > $TMP_EXISTCUR
   awk '{if ($4~/\/dev\// || $NF~/\/dev\//) if ($1~/c/ || $1~/b/) {print $NF} else {print $NF} else {print $NF}}' $EXISTBASE > $TMP_EXISTBASE
   sort -k 4 $CURRENT_EXIST  -o  $CURRENT_EXIST
   sort -k 4 $EXISTBASE -o $EXISTBASE
   diff $CURRENT_EXIST $EXISTBASE  > $TMP_EXISTCHANGE

####################################################################################
# 檢查是否有檔案異動
####################################################################################
   if [ -s $TMP_EXISTCHANGE ]; then
		  echo "#============================================================#"
		  awk '{print $NF}' $TMP_EXISTCHANGE | sort | uniq -d | grep -Ev '^$|^-' > $LIST_EXISTCHANGE
		  if [ -s $LIST_EXISTCHANGE ]; then
			  echo "EXISTCHANGE Failed" > $RESULT_EXIST
			  cat $LIST_EXISTCHANGE > $FILECHG_EXIST
			  echo "共有 `awk 'END {print NR}' $LIST_EXISTCHANGE` 檔案異動"

			  for LINE in `cat $LIST_EXISTCHANGE`
			  do
				 set -A LINE1 `grep " ${LINE}$" $EXISTBASE`
				 execStatus1=$?
				 if [ $execStatus1 -eq 0 ]; then
					echo "Base   :" ${LINE1[@]}
				 fi

				 set -A LINE2 `grep " ${LINE}$" $CURRENT_EXIST`
				 execStatus2=$?
				 if [ $execStatus2 -eq 0 ]; then
					echo "Current:" ${LINE2[@]}
#					print -n "         "
#					 let i=0
#					 while [ $i -lt ${#LINE2[@]} ] ; do
#							COUNT=${#LINE2[$i]} #count item length
#							if [[ ${LINE1[$i]} = ${LINE2[$i]} ]]; then #compare LINE1 and LINE2
#								seperater $COUNT ' ' #first para "count length", second para "insert char"
#							else
#								seperater $COUNT '^' #if item were different than show the '^' symbol below it
#							fi
#							let i+=1
#					 done
                	echo ""
				 fi
			  done
			  echo ---------------------------------------
		  else
          	  echo 無異動檔案
			  echo ---------------------------------------
		  fi
	 else
          echo 無異動檔案
		  echo ---------------------------------------
   fi
####################################################################################
# 檢查是否有新增檔案
####################################################################################
      sort $TMP_EXISTCUR -o $TMP_EXISTCUR
      sort $TMP_EXISTBASE -o $TMP_EXISTBASE
      # compare current and base, delete the empty line then output the added file
      comm -23 $TMP_EXISTCUR $TMP_EXISTBASE |grep -v '^$' > $LIST_EXISTADD
      if [ -s $LIST_EXISTADD ]; then #if file not empty
          echo "EXISTCHANGE ADD Failed" >> $RESULT_EXIST
          echo "共有 `awk 'END {print NR}' $LIST_EXISTADD` 檔案新增"

		  for ADD in `cat $LIST_EXISTADD`
		  do
			  grep " ${ADD}$" $CURRENT_EXIST
		  done

          echo ---------------------------------------
      else
          echo 無新增檔案
          echo ---------------------------------------
      fi
####################################################################################
# 檢查是否有被檔案刪除
####################################################################################
      comm -13 $TMP_EXISTCUR $TMP_EXISTBASE |grep -v '^$' > $LIST_EXISTDEL
      if [ -s $LIST_EXISTDEL ]; then
      echo "EXISTCHANGE DEL Failed" >> $RESULT_EXIST
          echo "共有 `awk 'END {print NR}' $LIST_EXISTDEL` 檔案刪除"

		  for DEL in `cat $LIST_EXISTDEL`
		  do
			  grep " ${DEL}$" $EXISTBASE
		  done

	  	  echo ---------------------------------------
      else
          echo 無檔案刪除
          echo ---------------------------------------
      fi

      # if file not empty
      if [ ! -s $TMP_EXISTCHANGE ] && [ ! -s $LIST_EXISTADD ] && [ ! -s $LIST_EXISTDEL ] ; then #if file not empty
		  echo "EXISTCHANGE OK" >> $RESULT_EXIST
      fi

else
   echo Basefile not exist, please execute the script '"genbas_file_attr.sh"' to create !
fi
tlog "Running check_exist end"
}
#}}}

#{{{check_modified
#----------------------------------
# Check files had been MODIFIED
# 檢查檔案時間屬性
#----------------------------------
check_modified(){
#set -x 

tlog "Running check_modified start"
# if BASEFILE exist
if [ -f $BASEFILE ]; then
echo 
echo 
echo "#============================================================#"
echo "# The SITE:$SITE"
echo "# The Hostname:$hostname"
echo "# 檢查檔案及目錄(含時間屬性)"
echo "# 共檢查 `awk 'END {print NR}' $BASEFILE` 檔案"
echo "# Date: `date +%Y/%m/%d\ %H:%M`"
echo "#============================================================#"
   # flush the file to make sure it's fresh
   cat /dev/null > $CURRENT
   # flush the check_status_file
   cat /dev/null > $RESULT #flush the check_status_file
   # import all dir_list from commandline prompt
   for DIRNAME in $DIR 
   do
	   find $DIRNAME 2>/dev/null  | xargs ls -lisd >> $CURRENT 2>/dev/null
	   find $DIRNAME -mtime -14 2>/dev/null  >> $TMP_CUR_MODI 2>/dev/null
#	   ${SHDIR}/sefind $DIRNAME -mtime -14 -ls 2> /dev/null | eval $ALLEXCLUDE >> $TMP_CUR_MODI
   done

   if [ ! -s $TMP_CUR_MODI ]; then
	   echo 無異動檔案
	   echo ---------------------------------------
	   echo 無新增檔案
	   echo ---------------------------------------
	   echo 無檔案刪除
	   echo ---------------------------------------
	   # return the final result to file
	   echo "MODIFIED OK" >> $RESULT
	   return 0
   fi
   # generate CURRENT status to compare with BASEFILE
   cat $CURRENT | eval $ALLEXCLUDE > ${CURRENT}.tmp
   mv ${CURRENT}.tmp $CURRENT
   sort -k 11 $CURRENT -o $CURRENT
   sort -k 11 $BASEFILE -o $BASEFILE
   # Second time create different base file and current file for compare again, /etc 不檢查其時間異動
   diff $CURRENT $BASEFILE | sed -e "/ \/etc$/d" > $TMP_CHANGE
   if [[ -s $TMP_CHANGE ]]; then

       awk '{print $12}' $TMP_CHANGE | sort -u | grep -Ev '^$|^-' > $LIST_CHANGE
	   while read LIST
	   do
		 grep -q " ${LIST}$" $BASEFILE && grep -q " ${LIST}$" $CURRENT && grep -q "^${LIST}$" $TMP_CUR_MODI  && echo $LIST
	   done < $LIST_CHANGE >> ${LIST_CHANGE}.tmp
	   mv ${LIST_CHANGE}.tmp ${LIST_CHANGE} 2>/dev/null

# 	   creative tmp_base tmp_current
#	   while read FF
#	   do
#		 FT=$(perl -e '@d=localtime ((stat(shift))[9]); printf "%02d:%02d\n", $d[2],$d[1]' $FF)
#         ls -lisd $FF | awk -v FT=$FT '{if ($10=FT) print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13}' >> $TMP_CUR
#         awk -v FNAME=$FF '{if ($11==FNAME) print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13}' $BASEFILE >> $TMP_BASE
#	   done < $LIST_CHANGE
#	   sort -k 11 $TMP_BASE -o $TMP_BASE
#	   sort -k 11 $TMP_CUR -o $TMP_CUR
   else
	   echo 無異動檔案
	   echo ---------------------------------------
	   echo 無新增檔案
	   echo ---------------------------------------
	   echo 無檔案刪除
	   echo ---------------------------------------
	   # return the final result to file
	   echo "MODIFIED OK" >> $RESULT
	   return 0
   fi

####################################################################################
# 檢查是否有檔案異動
####################################################################################
  if [ -s $LIST_CHANGE ]; then
	  # write faild log to result
	  echo "MODIFIED Failed" > $RESULT
      echo "共有 `awk 'END {print NR}' $LIST_CHANGE` 檔案異動"
      cat $LIST_CHANGE > $FILECHG 

      for LINE in `cat $LIST_CHANGE`
      do
			set -A LINE1 `grep " ${LINE}$" $BASEFILE | awk '$3 !~ /^l/'`
            echo "Base   :" ${LINE1[@]}

			set -A LINE2 `grep " ${LINE}$" $CURRENT | awk '$3 !~ /^l/'`
            echo "Current:" ${LINE2[@]}
			print -n "         "
			 let i=0
			 while [ $i -lt ${#LINE2[@]} ] ; do
					# count item length
					COUNT=${#LINE2[$i]}
					# compare LINE1 and LINE2
					if [[ ${LINE1[$i]} = ${LINE2[$i]} ]]; then
						# first para "count length", second para "insert char"
						seperater $COUNT ' '
					else
						# if item were different than show the '^' symbol below it
						seperater $COUNT '^' #if item were different than show the '^' symbol below it
					fi
				let i+=1
			 done
			 echo ""
      done
      echo ---------------------------------------
  else
      echo 無異動檔案
      echo ---------------------------------------
  fi
####################################################################################
# 檢查是否有新增檔案
####################################################################################
   # creative tmp_base tmp_current again
   awk '{if ($11~/\/dev\// || $12~/\/dev\//) if ($3~/c/ || $3~/b/) {print $12} else {print $11} else {print $11}}' $CURRENT > $TMP_CUR
   awk '{if ($11~/\/dev\// || $12~/\/dev\//) if ($3~/c/ || $3~/b/) {print $12} else {print $11} else {print $11}}' $BASEFILE > $TMP_BASE
      sort $TMP_CUR -o $TMP_CUR
      sort $TMP_BASE -o $TMP_BASE
      # compare current and base, delete the empty line then output the added file
      comm -23 $TMP_CUR $TMP_BASE |grep -v '^$' > $LIST_ADD
      # if file not empty
      if [ -s $LIST_ADD ]; then
          echo "MODIFIED ADD Failed" >> $RESULT 
          echo "共有 `awk 'END {print NR}' $LIST_ADD` 檔案新增"
          echo ---------------------------------------
		  for ADD in `cat $LIST_ADD`
		  do
			  grep " ${ADD}$" $CURRENT
		  done
		  echo ---------------------------------------
      else
          echo 無新增檔案
          echo ---------------------------------------
      fi

####################################################################################
# 檢查是否有被檔案刪除
####################################################################################
      # compare current and base, delete the empty line then output the deleted file
      comm -13 $TMP_CUR $TMP_BASE |grep -v '^$' > $LIST_DEL 
      # if file not empty
      if [ -s $LIST_DEL ]; then
          echo "MODIFIED DEL Failed" >> $RESULT 
          echo "共有 `awk 'END {print NR}' $LIST_DEL` 檔案刪除"
          echo ---------------------------------------
		  for DEL in `cat $LIST_DEL`
		  do
			  grep " ${DEL}$" $BASEFILE
		  done
	  echo ---------------------------------------
      else
          echo 無檔案刪除
          echo ---------------------------------------
      fi
      # if file not empty
      if [ ! -s $TMP_CHANGE ] && [ ! -s $LIST_ADD ] && [ ! -s $LIST_DEL ] ; then
		  # return the final result to file
		  echo "MODIFIED OK" >> $RESULT 
	  fi
else
   echo Basefile not exist, please execute the script '"genbas_file_attr.sh"' to create !
   exit 1
fi
tlog "Running check_modified end"
}
#}}}

#{{{main
main () {
#	check_base_file
	check_exist
#	check_modified
#	daily_check_status
	clear_tmp
}
#}}}

main
