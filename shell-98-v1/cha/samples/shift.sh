#! /bin/bash

echo "\$@ 的初值: $@"
while shift
do
   [ -n "$1" ] && echo "shift 1 次，\$@ 的變化: $@"
done
