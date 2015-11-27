#!/usr/bin/ksh

cd /tmp

tar -xvf file.tar

cd /tmp/file

for host in `cat /home/se/safechk/cfg/host.lst`
do
	echo "scp -P 2222 "$host".safelog.tar $host:/home/se/safechk"
	scp -P 2222 $host.safelog.tar $host:/home/se/safechk
#echo "ssh -p 2222 $host cd /home/se/safechk; tar -xvf $host.safelog.tar"
#	ssh -p 2222 $host "cd /home/se/safechk; tar -xvf $host.safelog.tar"
done
