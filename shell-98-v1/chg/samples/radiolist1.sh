#! /bin/bash

DIA='/usr/bin/dialog'

TMP="/tmp/radiolist.$$"
M1="請選擇您偏好的檔案系統"
NUMFS=3
FSLIST="ext2 第2版的擴展檔案系統 off ext3 第3版的擴展檔案系統 on ext4 第4版的擴展檔案系統 off"

$DIA --radiolist "$M1" 10 40 $NUMFS $FSLIST 2> $TMP

FSTYPE=$(cat $TMP)
[ -z "$FSTYPE" ] && FSTYPE="ext3"

rm -f "$TMP"

echo "您選擇的是: $FSTYPE"
