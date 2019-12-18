#!/bin/bash

# random_bash.sh - 使用bash的RANDOM變數來取得亂數

# 顯示10個亂數
for n in 1 2 3 4 5 6 7 8 9 10; do
    random=$(( (RANDOM % 10) + 1 ))
    echo -n "$random "
done
echo
