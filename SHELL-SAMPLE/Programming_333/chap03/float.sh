#!/bin/sh

# float.sh - 使用bc的浮點數運算

# 定義shell變數
A=5
B=7

# 若沒有設定scale的話，小數點以下會被捨去
echo 'scale=5; sqrt(1/3)' | bc

# 也可以使用here document來寫
bc <<EOF
scale=3
($A + 2) * $B / 11
EOF
