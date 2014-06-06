#! /bin/bash

shopt -s -o nounset

DestDir=~/tmp

while read f 
do
	echo $f
done < <(ls $DestDir | xargs -n 1)
