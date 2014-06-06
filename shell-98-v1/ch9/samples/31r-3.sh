#! /bin/bash

# 數學的三一律

declare -i a b
a=$1; b=$2

if [ $a -lt $b ]; then
   echo "$a 小於 $b"
elif [ $a -gt $b ]; then
   echo "$a 大於 $b"
else
   echo "$a 等於 $b"
fi
