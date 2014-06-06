#! /bin/bash

PS3='請選擇: '
menu="/ /root /etc /home /usr/local /var/log" 
select f in $menu
do
   echo "您鍵入的編號是 $REPLY, 選擇的目錄是: $f"
done
