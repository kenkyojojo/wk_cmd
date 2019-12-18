#!/bin/sh

# grepedit.sh - 用編輯器開啟符合正規表現的那一行

# 若引數的個數不正確的話，則顯示使用說明
if [ $# -ne 2 ]; then
    echo "usage: grepedit.sh regexp filename"
    exit 1
fi

regexp="$1"
filename="$2"

# 「rep -n」是表示以「行號:內容」的方式來顯示出找到的那一行內容的意思
# 若有找到與樣式符合的行，則行號會被存到「$1」中
# 若沒找到的話則是「NF」
IFS=':'
set -- `grep -n "$regexp" "$filename" || echo 'NF'`

# 若沒找到與正規表現符合的行，則顯示錯誤
if [ "$1" = "NF" ]; then
    echo "pattern not found."
    exit 1
fi

# 若EDITOR沒有被設定的話則使用vi
${EDITOR:-vi} +$1 "$filename"
