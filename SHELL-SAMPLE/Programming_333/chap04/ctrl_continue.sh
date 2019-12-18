#!/bin/sh

# ctrl_continue.sh - continue的例子

# 只顯示奇數
for n in 1 2 3 4 5 6 7 8 9 10; do
    r=`expr $n % 2`           # 計數a÷b的餘數
    [ $r -eq 0 ] && continue  # 若餘數為0，則進到下一次迴圈
    echo "$n is odd"          # 若為奇數的話，則顯示出來
done
