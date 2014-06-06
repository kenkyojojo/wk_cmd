#! /bin/bash

DIA='/usr/bin/Xdialog'

TMP="/tmp/inputbox.$$"

DEFPWD="password999"
M1="請設定密碼:"

$DIA --password --inputbox "$M1" 10 40 $DEFPWD 2> $TMP

PWD=$(cat $TMP)
[ -z "$PWD" ] && PWD=$DEFPWD

rm -f "$TMP"

echo "您設定的密碼是: $PWD"
