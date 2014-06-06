#! /bin/bash

DIFF="/usr/bin/diff"

test_filequal() {
   File1=$1
   File2=$2
   $DIFF $File1 $File2 &> /dev/null
   return $?
}
