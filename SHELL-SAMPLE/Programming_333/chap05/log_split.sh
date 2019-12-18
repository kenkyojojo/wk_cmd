#!/bin/sh

# log_split.sh - 將logfile分割為適當大小，並壓縮之

lpf=100  # 每100行做一次分割

# 若檔名沒有被指定的話，顯示使用說明
if [ $# -ne 1 ]; then
    echo "usage: log_split.sh logfile"
    exit 1
fi

# 設定對象檔案的名稱，和去掉資料夾名稱的名稱
logfile="$1"
splitbase=`basename "$1"`.

# 把檔案做分割，若分割成功的話則分別去做壓縮
if split -l $lpf "$logfile" "$splitbase"; then
    for split in "$splitbase"*; do
	gzip "$split"
    done
fi
