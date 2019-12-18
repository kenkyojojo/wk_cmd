#!/bin/sh

# args.sh - 將接收到的引數兩個兩個顯示出來

# 顯示引數的總數
echo "Number of arguments: $#"

# 兩個兩個顯示
while [ -n "$1" ]; do  # 在$1不是null之前，不斷重複這個動作
    echo "$1 $2"
    shift 2
done
