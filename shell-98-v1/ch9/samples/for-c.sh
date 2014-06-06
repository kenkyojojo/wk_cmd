#! /bin/bash

declare -i i sum
for ((i=0; i<10; i=i+1))
do
   sum+=i
done

echo $sum
