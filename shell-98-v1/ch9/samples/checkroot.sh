#! /bin/bash

if [ "$LOGNAME" != "root" ]; then
   echo '本程式須使用 root 權限執行.'
   exit 1
fi

echo '現在您正以 root 權限執行本程式....'
