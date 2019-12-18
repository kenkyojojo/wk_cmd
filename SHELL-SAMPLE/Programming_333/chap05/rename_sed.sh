#!/bin/sh

# rename_sed.sh - 使用正規表現變更檔名

# 若沒有引數的話，則顯示使用說明
if [ $# -lt 3 ]; then
    echo "usage: rename_sed.sh regexp replace files..."
    exit 1
fi

# 設定正規表現與取代字串
regexp="$1"
pattern="$2"
shift 2

# 對其它的引數指定的檔案做重複處理
for orig do
    new=`echo "$orig" | sed s/"$regexp"/"$pattern"/`
    echo "$orig -> $new"
    mv "$orig" "$new"
done
