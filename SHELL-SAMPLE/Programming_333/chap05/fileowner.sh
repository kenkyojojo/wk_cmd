#!/bin/sh

# fileowner.sh - 傳回檔案的擁有者

# 若被給定的引數數量不對的話，則顯示使用方法
if [ $# -ne 2 ]; then
    echo "usage: fileowner.sh -u|-g filename"
    exit 1
fi

# 解析選項
case "$1" in
    "-u")
	show="user"  ;;
    "-g")
	show="group" ;;
    *)
	echo "$1: unknown option"
	exit 1
esac

# 將「ls -l」的輸出用set分割成多個單字
set -- `ls -l -d "$2"`

# 分解結果
# $1 - 存取權
# $2 - 硬體連結數
# $3 - 擁有者使用者
# $4 - 擁有者群組
# $5 - 大小
# $6 - 最終更新日期的「月」
# $7 - 最終更新日期的「日」
# $8 - 最終更新日期的「年」或是「時:分」
# $9之後 - 檔名

# 顯示結果
[ "$show" = "user" ] && echo "$3" || echo "$4"
