#! /bin/bash

DIA='/usr/bin/dialog'

$DIA --msgbox "這是一個測試" 10 40
x=$?
if [ "$x" -eq 0 ]; then
   echo '您按了 ENTER 鍵'
elif [ "$x" -eq 255 ]; then
   echo '您按了 ESC 鍵'
else
   echo '未知的錯誤: 您可能按了 Ctrl-C 鍵'
fi
