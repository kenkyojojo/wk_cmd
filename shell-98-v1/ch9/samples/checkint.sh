#! /bin/bash

declare -i len
len=$1

if [ $len -eq 100 ]; then
   echo '長度 100'
else
   echo "長度不是 100，而是 $len"
fi
