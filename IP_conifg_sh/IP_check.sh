#!/usr/bin/ksh

for HOST in `cat /tmp/host.log` ; 
do

   echo $HOST >> IP_check.log
   ssh -p 2222 $HOST 'ifconfig -a ' >> IP_check.log
   echo "###################################################################" >> IP_check.log

   #execStatus=$?
   #if [ $execStatus -eq 0 ]; then
   #   echo "$HOST OK!" >> /tmp/ssh.log
   #else
   #   echo "$HOST Fail!" >> /tmp/ssh.log
   #fi
done

