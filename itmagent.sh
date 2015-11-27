#!/usr/bin/ksh

for host in `cat /tmp/host.lst`
do
	echo "stop itmagent"
#ssh -p 2222 -f seadm@host "/opt/IBM/ITM/bin/itmcmd agent -f stop all" 
	ssh -p 2222 -f root@host "/tmp/itmagent_tar.sh" 
	ssh -p 2222 -f root@host "/tmp/??.pl" 
	echo "stop itmagent finished"
done
