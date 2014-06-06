#!/bin/bash
N=0
while [ "$N" -le 100 ] 
do
	ls -l 
	df -h
	(( N= $N + 1 ))
done > while2.tmp

