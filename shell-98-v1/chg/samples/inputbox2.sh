#! /bin/bash

DIA='/usr/bin/Xdialog'

TMP="/tmp/inputbox.$$"

DEFHNAME="sample.edu.tw"
M1="請設定主機名稱:"

$DIA --inputbox "$M1" 10 40 $DEFHNAME 2> $TMP

HNAME=$(cat $TMP)
[ -z "$HNAME" ] && HNAME=$DEFHNAME

rm -f "$TMP"

echo "您設定的主機名稱是: $HNAME"
