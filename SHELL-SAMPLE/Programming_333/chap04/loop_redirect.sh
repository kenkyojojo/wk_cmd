#!/bin/sh

# loop_redirect.sh - 將重複處理的輸出重新導向

for name in *.txt; do
    echo "$name"
done >tmp.out
