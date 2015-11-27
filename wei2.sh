#!/usr/bin/ksh
USER=otc
HOSTLIST=/home/se/safechk/cfg/host.lst
set -A OTC_USER `cat /home/se/safechk/cfg/host.lst`
for OTC in ${OTC_USER[@]}     
do
	echo $OTC
done     
