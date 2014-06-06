#! /bin/bash

# 修改 vsftpd 的設定檔，開放匿名 FTP 服務

VSFTPD_conf='/etc/vsftpd.conf'
TMP_file="/tmp/tmp.$$"

# 將 anonymous_enable 選項，設成 YES，這樣，vsftpd 就會開啟匿名登入 FTP 伺服器的功能。
sed s/^.*anonymous_enable=.*/anonymous_enable=YES/ $VSFTPD_conf > $TMP_file
mv -f $TMP_file $VSFTPD_conf
