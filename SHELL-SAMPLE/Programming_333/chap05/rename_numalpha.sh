#!/bin/sh

# rename_numalpha.sh - 將檔名中的一位數的數字換成英文字
#                      (1=A, 2=B, ..., 9=I)

# 若沒有引數的話，則顯示使用說明
if [ $# -eq 0 ]; then
    echo "usage: rename_numalpha.sh files..."
    exit 1
fi

# 對引數所指定的所有檔名做同樣的處理
for orig do
    new=`echo "$orig" | ruby -pe 'gsub!(/[1-9]/) { |m| (m.to_i+64).chr }'`
    echo "$orig -> $new"
    mv "$orig" "$new"
done
