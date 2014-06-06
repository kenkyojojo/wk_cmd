#! /bin/bash

# 修改 vsftpd 的設定檔，切換：'開放/關閉' 匿名 FTP 服務

if [ $# -ne 1 ]; then
   echo "Usage: $0 on 或 $0 off"
   exit 1
fi

OPT=$1
case "$OPT" in
   [Oo][Nn]) CMD='YES';;
   [Oo][Ff][Ff]) CMD='NO';;
   *) 
     echo '選項格式錯誤! 請用 on 或 off 來切換匿名登入的開關。' 
     exit 1
     ;;
esac

VSFTPD_conf='/etc/vsftpd.conf'
TMP_file="/tmp/tmp.$$"

sed s/^.*anonymous_enable=.*/anonymous_enable=$CMD/ $VSFTPD_conf > $TMP_file
mv -f $TMP_file $VSFTPD_conf
