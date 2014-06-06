#! /bin/bash

DIA='/usr/bin/dialog'

TMP="/tmp/passwordbox.$$"

DEFPWD='b2d is best'
M1="請設定一組密碼:"

$DIA --insecure --passwordbox "$M1" 10 40 2> $TMP

PWD=$(cat $TMP)
[ -z "$PWD" ] && PWD=$DEFPWD

rm -f "$TMP"

echo "您設定的密碼是: $PWD"
