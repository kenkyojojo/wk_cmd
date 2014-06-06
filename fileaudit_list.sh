#!/usr/bin/ksh
a=$(find /etc -ls | cut -c1-61)
b=$(find /etc -ls | cut -c67-)
for ff in $(find /etc -ls| awk '/\// {print $11}')
do
perl -e '@d=localtime ((stat(shift))[9]); printf "%02d-%02d-%04d %02d:%02d:%02d\n", $d[3],$d[4]+1,$d[5]+1900,$d[2],$d[1],$d[0]' $ff>> /tmp/b.txt
done
