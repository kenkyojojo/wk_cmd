#!/bin/sh

# ctrl_until.sh - until的例子

# 在某祕密單字被輸入之前，一直重複同樣的動作
# read這個內建指令，會從標準輸入讀入一行資料，存放到指定的變數中
secret=''
until [ "$secret" = "secret" ]; do
    echo -n "Enter secret word: "
    # echo "Enter secret word: \c"  # Solaris
    read secret
done
echo "Bingo!"
