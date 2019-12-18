#!/bin/bash

# array_bash_paren.sh - 一次將多個值設定到bash的陣列變數中

# ( ... )中所括的單字會被放到陣列中
array=(first "second" 'third with space' fourth\ with\ space)

# 顯示各要素
for n in 0 1 2 3; do
    echo "${array[$n]}"
done
