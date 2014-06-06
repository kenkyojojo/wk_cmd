#!/usr/bin/ksh

OLDIFS=$IFS
IFS='\n'

a=$(ls -l /tmp)

IFS=$OLDIFS
echo $a

