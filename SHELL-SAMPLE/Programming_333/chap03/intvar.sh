#!/bin/bash

# intvar.sh - bash的整數變數的例子

# 將i, j, k宣告為整數變數
declare -i i j k

i=3
j=4
k=i*j          # 四則運算
i='(i+123)/j'  # 若要使用( )的話，必須將右邊整個用 "..." 或 '...' 括起來

echo "i=$i j=$j k=$k"
