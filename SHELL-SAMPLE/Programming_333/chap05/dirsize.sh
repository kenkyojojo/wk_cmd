#!/bin/sh

# dirsize.sh - 傳回資料夾的大小(磁碟使用量)

# 若沒有指定引數的話，則顯示使用說明
if [ $# -ne 1 ]; then
    echo "usage: dirsize.sh dirname"
    exit 1
fi

# 將「du -ks」的輸出結果用set分割成多個單字
set -- `du -ks "$1"`

# 分解結果
# $1 - 大小(以KB為單位)
# $2之後 - 資料夾名稱

# 顯示大小(以位元組為單位)
expr $1 \* 1024
