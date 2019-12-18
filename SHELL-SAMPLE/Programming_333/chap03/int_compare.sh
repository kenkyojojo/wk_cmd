#!/bin/sh

# int_compare.sh - 整數的比較

a=3
b=5
c=3

# a < b ?
if [ $a -lt $b ]; then
    echo "$a is less than $b"
fi

# a == c ?
if [ $a -eq $c ]; then
    echo "$a is equal to $c"
fi

# a == b ?
if [ $a -eq $b ]; then
    echo "$a is equal to $b"
else
    echo "$a is NOT equal to $b"
fi
