#! /bin/bash

DIA='/usr/bin/Xdialog'

TMP="/tmp/inputbox.$$"

DEFACT="root"
DEFPWD="password999"
M1="請設定帳號密碼:"

$DIA --password --2inputsbox "$M1" 16 40 "帳號" $DEFACT "密碼" $DEFPWD 2> $TMP

R=( $(cat $TMP | awk -F/ '{print $1,$2}') )

[ -z "${R[0]}" ] && R[0]=$DEFACT
[ -z "${R[1]}" ] && R[1]=$DEFPWD

rm -f "$TMP"

echo "您設定的帳號是: ${R[0]}"
echo "您設定的密碼是: ${R[1]}"
