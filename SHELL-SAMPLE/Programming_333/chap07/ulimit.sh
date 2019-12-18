#!/bin/sh

# ulimit.sh - ulimit的範例

# 限制CPU時間
ulimit -t 1

# 永遠重複複雜的計算
i=1
while true; do
  i=`expr $i \* -5 + 20`
done
