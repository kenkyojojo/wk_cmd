#!/bin/sh

# disk_free.sh - 取得指定的資料夾、檔案所在的磁碟的可用空間

# 若引數的個數不正確的話，顯示使用方法
if [ $# -eq 0 ]; then
    echo "usage: disk_free.sh file_or_dir"
    exit 1
fi

# 將df指令的輸出分解為多個單字，然後只顯示有必要的部分
set -- `df -k "$1" | tail -1`
echo $4
