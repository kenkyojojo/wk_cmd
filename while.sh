#!/bin/bash
N=0
#while [ "$N" -le 100 ] 
for host  in `cat $@`
do
#	ls -l $1 >> while.tmp
#	df -h  $1 >> while.tmp
#	(( N= $N + 1 ))
	echo $host
done < dir.list > while.tmp
