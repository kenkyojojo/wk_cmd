#!/bin/sh

# loop_pipe.sh - 將重複處理的輸出導到pipe中

for capital in London Paris Beijing Pusan Washington; do
    echo "$capital"
done | sort
