#!/bin/sh

# dir.sh - 顯示指定的資料夾內的檔案一覽

dir="$1"

# 指定的資料夾內的檔案一覽會被設定到$1, $2... 中
set -- "$dir"/*

# 顯示資訊
echo "Directory: $dir"
echo "Number of files: $#"
echo "List of files:"

# 對$1,$2...(檔名一覽)做重複處理
for name do
    echo "  $name"
done
