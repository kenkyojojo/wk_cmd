#!/bin/sh

# ctrl_break.sh - break的例子

for item in one two three STOP four five; do
    [ "$item" = "STOP" ] && break  # 若是「STOP」的話，則中斷for迴圈
    echo "$item"
done
