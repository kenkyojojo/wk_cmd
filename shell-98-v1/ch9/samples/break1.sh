#! /bin/bash

for ((i=1;i<=10;i++))
do
   if [ $i -eq 6 ]; then
      break
   fi
   echo $i
done
