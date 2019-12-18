#!/bin/sh

# cmddir.sh - 顯示存放著引數所指定的指令的資料夾

fullpath=`which "$1"`   # 取得指令的完整路徑
[ $? -ne 0 ] && exit 1  # 若找不到此指令，則結束

dirname "$fullpath"
