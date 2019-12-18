#!/bin/sh

# file_inode.sh - 調查檔案的i node編號

# 將ls的輸出分解成多個單字
set -- `ls -i -d "$1"`

# 分解結果
# $1 - i node編號
# $2以後 - 檔案名稱

# 顯示i node編號
echo "$1"
