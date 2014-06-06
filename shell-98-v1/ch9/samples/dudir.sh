#! /bin/bash

DIR="/var"
cd $DIR
for f in $(ls $DIR)
do
   [ -d $f ] && du -s $f
done 
