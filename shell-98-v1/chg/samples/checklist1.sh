#! /bin/bash

DIA='/usr/bin/dialog'

TMP="/tmp/checklist.$$"
M1="請選擇您偏好的檔案系統"
FSLIST="1.ext2 第2版的擴展檔案系統 on 2.ext3 第3版的擴展檔案系統 on 3.ext4 第4版的擴展檔案系統 off"

$DIA --checklist "$M1" 10 40 4 $FSLIST 2> $TMP

FSTYPE=$(cat $TMP)
[ -z "$FSTYPE" ] && FSTYPE="ext3"

rm -f "$TMP"

echo "您選擇的是: $FSTYPE"
