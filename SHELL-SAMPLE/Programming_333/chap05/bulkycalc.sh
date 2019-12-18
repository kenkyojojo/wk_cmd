#!/bin/sh

# bulkycalc.sh - 一次進行多個計算

# 輸入檔中每行寫一個計算式。bc會從標準輸入逐行取得算式，並計算之。
# 結果會被存在暫存檔中。
# 最後用paste將輸入檔和結果做結合

# 若引數的個數不正確的話，則顯示使用說明
if [ $# -ne 1 ]; then
    echo "usage: bulkycalc.sh input-file"
    exit 1
fi

# 製作暫存檔
temp=`mktemp /tmp/bulkycalc.XXXXXXXX` || exit 1

cat "$1" | bc > "$temp"  # 進行計算
paste -d = "$1" "$temp"  # 將計算結果則到輸入檔

# 刪除暫存檔
rm "$temp"
