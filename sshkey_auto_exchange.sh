#!/bin/ksh
USER=/tmp/user.lst
WKLA=WKLPARA1
WKLB=WKLPARB1
HOSTNAME=`hostname`

if [[ $HOSTNAME = $WKLA ]] ; then
	for user in `cat $USER`
	do
		Homedir=`lsuser -a home $user | awk -F '=' '{print $2}'`
		GP=`lsuser -a groups $user | awk -F '=' '{print $2}'`
		cat ${Homedir}/.ssh/id_rsa.pub | ssh -p 2222 root@${WKLB} "cat - >> ${Homedir}/.ssh/authorized_keys"
		su - $user -c  ssh -p 2222 -o StrictHostKeyChecking=no $WKLB "ls -ld /tmp"
	done
else
	for user in `cat $USER`
	do
		Homedir=`lsuser -a home $user | awk -F '=' '{print $2}'`
		GP=`lsuser -a groups $user | awk -F '=' '{print $2}'`
		cat ${Homedir}/.ssh/id_rsa.pub | ssh -p 2222 root@${WKLA} "cat - >> ${Homrdir}/.ssh/authorized_keys"
		su - $user -c  ssh -p 2222 -o StrictHostKeyChecking=no $WKLA "ls -ld /tmp"
	done
fi
