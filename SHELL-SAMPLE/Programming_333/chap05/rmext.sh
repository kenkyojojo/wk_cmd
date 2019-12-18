#!/bin/sh

# rmext.sh - 從檔名去除副檔名

# 使用expr的處理
rmext_expr() {
    bname=`expr "$1" : '\(.*\)\.'`
    [ $? -eq 0 ] && echo "$bname" || echo "$1"
}

# 使用sed的處理
rmext_sed() {
    echo "$1" | sed 's/\.[^.]*$//'
}

# 選擇expr版本或sed版本
rmext_expr "$1"
#rmext_sed "$1"
