#! /bin/bash

p=$1

HostCmd="/bin/hostname"
# 取得主機名稱
HostName=$($HostCmd)

if [ -n "$p" ]; then
   if [ $p = host ]; then
      MachineName=${HostName%%.*}
      echo $MachineName ; exit 0
   elif [ $p = domain ]; then
      Domain=${HostName#*.}
      echo $Domain; exit 0
   fi
fi

echo $HostName
