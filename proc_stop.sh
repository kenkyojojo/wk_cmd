#!/usr/bin/sh
#Editor:TWSE_1150
#Date:103/11/27
#Function:Stop unnecessary AIX OS initiate processes
#Note:Need root to execute this script (chmod 744)

#Backup original .conf
cp -p /etc/inetd.conf /tmp/proc_stop/inetd.conf.bk
cp -p /etc/inittab /tmp/proc_stop/inittab.bk
cp -p /etc/rc.tcpip /tmp/proc_stop/rc.tcpip.bk

#Restore original .conf
#cp -p /tmp/proc_stop/inetd.conf.bk /etc/inetd.conf
#cp -p /tmp/proc_stop/inittab.bk /etc/inittab
#cp -p /tmp/proc_stop/rc.tcpip.bk /etc/rc.tcpip

#Immediate make inetd proc close
refresh -s inetd

#Stop subsystem
stopsrc -s pconsole
stopsrc -s qdaemon
stopsrc -s writesrv

#Stop subsystem group
stopsrc -g nfs
stopsrc -g nimclient

#Stop IBM Systems Director Agent
 #Stop and disable common agent
 /opt/ibm/director/agent/runtime/agent/bin/endpoint.sh stop
 #Remove SD start on boot
 /opt/ibm/director/agent/runtime/nonstop/bin/installnonstop.sh -uninstallservice
 #Stop platform agent
 stopsrc -s platform_agent
 stopsrc -s cas_agent
 #Stop cimserver
 stopsrc -s cimsys

#stop daemon in rc.tcpip
chrctcp -S -d sendmail
chrctcp -S -d snmpd
chrctcp -S -d aixmibd
chrctcp -S -d snmpmibd
chrctcp -S -d hostmibd
chrctcp -S -d portmap

#stop inittab service
chitab "platform_agent:2:off:/usr/bin/startsrc -s platform_agent >/dev/null 2>&1" #"platform_agent:2:once:/usr/bin/startsrc -s platform_agent >/dev/null 2>&1"
chitab "nimsh:2:off:/usr/bin/startsrc -g nimclient >/dev/console 2>&1" #"nimsh:2:wait:/usr/bin/startsrc -g nimclient >/dev/console 2>&1"
chitab "rcnfs:23456789:off:/etc/rc.nfs > /dev/console 2>&1" #"rcnfs:23456789:wait:/etc/rc.nfs > /dev/console 2>&1"
chitab "nimclient:2:off:/usr/sbin/nimclient -S running > /dev/console 2>&1" #"nimclient:2:once:/usr/sbin/nimclient -S running > /dev/console 2>&1"
chitab "qdaemon:23456789:off:/usr/bin/startsrc -sqdaemon" #"qdaemon:23456789:wait:/usr/bin/startsrc -sqdaemon"
chitab "writesrv:23456789:off:/usr/bin/startsrc -swritesrv" #"writesrv:23456789:wait:/usr/bin/startsrc -swritesrv"
chitab "uprintfd:23456789:off:/usr/sbin/uprintfd" #"uprintfd:23456789:respawn:/usr/sbin/uprintfd"
chitab "cimservices:2:off:/usr/bin/startsrc -s cimsys >/dev/null 2>&1" #"cimservices:2:once:/usr/bin/startsrc -s cimsys >/dev/null 2>&1"
chitab "pconsole:2:off:/usr/bin/startsrc -s pconsole > /dev/null 2>&1" #pconsole:2:once:/usr/bin/startsrc -s pconsole  > /dev/null 2>&1
chitab "cas_agent:2:off:/usr/bin/startsrc -s cas_agent >/dev/null 2>&1" #"cas_agent:2:once:/usr/bin/startsrc -s cas_agent >/dev/null 2>&1"

#stop inetd.conf service
sed 's/ftp/#ftp/' /tmp/proc_stop/inetd.conf.bk > /tmp/proc_stop/inetd.conf.tmp1
sed 's/t#ftp/#tftp/' /tmp/proc_stop/inetd.conf.tmp1 > /tmp/proc_stop/inetd.conf.tmp2
sed 's/exec/#exec/' /tmp/proc_stop/inetd.conf.tmp2 > /tmp/proc_stop/inetd.conf.tmp1
sed 's/ntalk/#ntalk/' /tmp/proc_stop/inetd.conf.tmp1 > /tmp/proc_stop/inetd.conf.tmp2
sed 's/daytime/#daytime/' /tmp/proc_stop/inetd.conf.tmp2 > /tmp/proc_stop/inetd.conf.tmp1
sed 's/time/#time/' /tmp/proc_stop/inetd.conf.tmp1 > /tmp/proc_stop/inetd.conf.tmp2
sed 's/xmquery/#xmquery/' /tmp/proc_stop/inetd.conf.tmp2 > /tmp/proc_stop/inetd.conf.tmp1
sed 's/bfagent stream tcp6/#bfagent stream tcp6/' /tmp/proc_stop/inetd.conf.tmp1 > /tmp/proc_stop/inetd.conf.tmp2
mv /tmp/proc_stop/inetd.conf.tmp2 /etc/inetd.conf
rm /tmp/proc_stop/inetd.conf.tmp1 /tmp/proc_stop/inetd.conf.tmp2

#kill processes already started in inittab
set -A KILL_PROC uprintfd xmtopasagg defunc xmtopas

integer count=0

for i in ${KILL_PROC[*]}
do
        tmp=`ps -ef | grep -v grep | grep  $i| awk '{print $2}'`
        if [ $tmp ] ; then
                PID[count]="$tmp"
        fi
count=count+1
done

kill -9  ${PID[*]}