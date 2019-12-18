#!/bin/sh

# trap_int.sh - trap指令的範例

# 忽略INT訊號
trap 'echo "SIGINT was ignored."' INT

# 會花時間的處理
for i in one two three four five; do
    echo $i
    sleep 1
done
