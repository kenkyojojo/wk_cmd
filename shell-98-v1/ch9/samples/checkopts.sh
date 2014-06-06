#! /bin/bash

set -o

if [ -o history ]; then
   echo 'Bash 選項 history 開啟.'
else
   echo 'Bash 選項 history 關閉.'
fi
