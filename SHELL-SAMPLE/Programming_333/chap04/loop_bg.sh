#!/bin/sh

# loop_bg.sh - 在背景進行重複處理

for i in 5 4 3 2 1 "Fire!"; do
    echo "$i"
    sleep 1
done &

sleep 6
