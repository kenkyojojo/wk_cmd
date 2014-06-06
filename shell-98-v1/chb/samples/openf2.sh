#! /bin/bash

datafile='dataf1'
exec 3<&0
exec < $datafile

while read
do
   echo $REPLY
done

exec 0<&3 3<&-
