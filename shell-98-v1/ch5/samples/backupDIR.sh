#! /bin/bash

A="/root/tmp/test2"
B="/root/tmp/test4"

cd $A
tar cvf - . | tar xvf - -C $B
