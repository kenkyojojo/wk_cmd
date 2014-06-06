#! /bin/bash

Flist=${1:?'錯誤! 請提供要轉換編碼的檔案列表!'}

scode="big5"
dcode="utf8"

for FILE in $(cat $Flist)
do
   TMP_file=$(mktemp -p $(pwd))
   if [ -f $FILE ]; then
      Fright=$(stat -c %a $FILE)
      Fuser=$(stat -c %U $FILE)
      Fgrp=$(stat -c %G $FILE)
      iconv -f $scode -t $dcode $FILE -o $TMP_file
      mv $TMP_file $FILE
      chmod $Fright $FILE
      chown $Fuser.$Fgrp $FILE
   fi
done
