#! /bin/bash

Dir="/usr/local/bin"

for f in $Dir/*
do
   if [ -x "$f" ]; then
      tar cvf /dev/nst0 $f
   fi
done
