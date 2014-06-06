#! /bin/bash

# 數學的三一律

declare -i a b
a=$1; b=$2

if let "a<b"; then
   echo "$a 小於 $b"
elif let "a>b"; then
   echo "$a 大於 $b"
else
   echo "$a 等於 $b"
fi
