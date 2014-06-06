#! /bin/bash

datafile='dataf1'
exec 3<>$datafile
while read <&3
do
   echo $REPLY
done
exec 3<&-
