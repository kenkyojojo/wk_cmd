#!/bin/sh

# arith.sh - 使用expr的四則運算

x=5
y=9
z=13

# 「*」(乘法)或「(」「)」的前面必須要放上「\」
a=`expr $x \* $y`
b=`expr \( $y + $z \) / $x`

echo "$a"
echo "$b"
