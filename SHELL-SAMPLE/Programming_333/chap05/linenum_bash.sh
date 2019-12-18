#!/bin/bash

# linenum_bash.sh - 為檔案加上行號

# 若引數的數量不正確的話，則顯示使用說明
if [ $# -ne 1 ]; then
    echo "usage: linenum_bash.sh filename"
    exit 1
fi

IFS=$'\n'          # IFS中指定換行文字
file=(`cat "$1"`)  # 將檔案讀入到檔案中

# 將各行與行數一同顯示
ln=0
for line in "${file[@]}"; do
    ln=`expr $ln + 1`
    printf '%3d %s\n' "$ln" "$line"
done
