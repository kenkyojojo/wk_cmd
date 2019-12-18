#!/bin/sh

# currenttime.sh - 定時將現在時刻寫入到檔案中

# 永遠重複 do ... done之間的部分
while true; do
    # 將現在時刻寫入到home directory的current time中
    date +'%H:%M:%S' >"$HOME/currenttime"
    # 等待一秒鐘
    sleep 1
done
