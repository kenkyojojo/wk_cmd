#!/bin/bash

# array_bash.sh - bash的陣列變數

# 將值設定到陣列中
sample[0]="zero"
sample[1]="one"
sample[2]="two"

# 顯示各要素的值
for i in 0 1 2; do
    echo "sample[$i]=${sample[$i]}"
done
