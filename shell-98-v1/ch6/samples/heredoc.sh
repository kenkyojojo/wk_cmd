#! /bin/bash

# 這裡放了一段程式碼
: <<BASH-CODE
NAME=ipw2200
DESC="Intel PRO/Wireless 2200BG"

echo "Starting $DESC: $NAME"
pump -k
NETDEVICES="$(cat /proc/net/dev | awk -F: '/eth.:|tr.:|wlan.:/{print $1}')"
for i in $NETDEVICES
do
   ifconfig $i down
done
if (lsmod | grep -q ipw2200); then
   rmmod ipw2200
fi
modprobe ipw2200
service networking restart

BASH-CODE

echo 'BASH-CODE 不會執行'

