#!/bin/sh

# ctrl_while.sh - while敘述的例子

# 顯示所有的引數
while [ -n "$1" ]; do
    echo "$1"
    shift
done
