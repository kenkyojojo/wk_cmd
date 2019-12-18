#!/bin/bash

# array_bash_count.sh - 計算bash陣列變數的要素數

# 編號有連續的情況
sample1[0]="zero"
sample1[1]="one"
sample1[2]="two"
echo ${#sample1[*]}

# 編號不連續的情況
sample2[1]="first"
sample2[7]="second"
sample2[10]="third"
echo ${#sample2[*]}
