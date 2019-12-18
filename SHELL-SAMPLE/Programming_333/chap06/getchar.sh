#!/bin/sh

# getchar.sh - 輸入1個字的範例

echo "Hit any key!"

stty raw -echo
char=`dd bs=1 count=1 2>/dev/null`
stty -raw echo

echo "Key pressed: '$char'"
