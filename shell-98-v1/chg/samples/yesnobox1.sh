#! /bin/bash

DIA='/usr/bin/dialog'

CHOICE=''

dialog --yesno "要繼續嗎?" 10 40
x=$?
if [ "$x" -ne 0 ]; then
   CHOICE='NO'
fi

if [ -n "$CHOICE" ]; then
   echo '您選擇不繼續...'
else
   echo '您選擇繼續...'
fi
