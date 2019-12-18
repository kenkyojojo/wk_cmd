#!/usr/bin/ksh

EXCLUDE="Thu Mar  3 13:37:08"
BKDIR=/tmp/backup_login_info
mkdir $BKDIR
	cp -i /var/adm/wtmp ${BKDIR}/
	cp -i /etc/utmp  ${BKDIR}/

	/usr/sbin/acct/fwtmp < /var/adm/wtmp > /tmp/wtmp 
	grep -v  $EXCLUDE  /tmp/wtmp > /tmp/wtmp.tmp
	cat /tmp/wtmp.tmp | /usr/sbin/acct/fwtmp -ic > /tmp/wtmp 
#	rm /tmp/wtmp
#	rm /tmp/wtmp.tmp

	/usr/sbin/acct/fwtmp < /etc/utmp > /tmp/utmp 
	grep -v  $EXCLUDE  /tmp/utmp > /tmp/utmp.tmp
	cat /tmp/utmp.tmp | /usr/sbin/acct/fwtmp -ic > /tmp/utmp 
#	rm /tmp/utmp
#	rm /tmp/utmp.tmp
