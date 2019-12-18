#!/bin/sh

# linenum.sh - 為檔案加上行號

# 若引數個數不正常的話，則顯示說明
if [ $# -ne 1 ]; then
    echo "usage: linenum.sh filename"
    exit 1
fi

# 在IFS中指定換行文字
IFS='
'
ln=0

# 從標準輸入逐行讀入資料，與行號一同顯示
while read -r line; do  # Solaris的read line
    ln=`expr $ln + 1`
    printf '%3d %s\n' "$ln" "$line"
done < "$1"

# 註:若read的「-r」選項不能使用的話，
# 則無法正常使用包含「\」的輸入檔
