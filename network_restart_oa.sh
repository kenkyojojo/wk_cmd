#!/bin/bash
#sudo echo "nameserver 10.1.10.11" >> /etc/resolv.conf
# rdesktop-vrdp -u itswebdac -d tsecdm -p p@ssw0rd 10.51.101.141
# rdesktop-vrdp -u itswebdac -d tsecdm -p p@ssw0rd 10.51.101.142
# rdesktop-vrdp -u itswebdac -d tsecdm -p p@ssw0rd 10.51.101.143
# rdesktop-vrdp -u se99usr -d audit -p p@ssw0rd 172.17.3.33 開發
# rdesktop-vrdp -u se99usr -d audit -p p@ssw0rd 172.17.3.32 測試
# sudo mount -t  cifs -o username=itswebdac,password=p@ssw0rd //10.51.101.141/backup /media/bruce
sudo ifconfig eth0 10.1.221.54 netmask 255.255.255.224 
sudo route add -net 10.1.221.0 netmask 255.255.255.224 dev eth0 gw 10.1.221.62
sudo route add default gw  10.1.221.62 dev eth0
