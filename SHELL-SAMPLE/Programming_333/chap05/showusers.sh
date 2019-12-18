#!/bin/sh

# showusers.sh - 將登錄在系統中的使用者一覽表用本名顯示出來

if [ `uname` = "Darwin" ]; then
    # Mac OS X中是不使用/etc/passwd的
    nidump passwd . | cut -d : -f 8
else
    # 其它的系統
    cat /etc/passwd | cut -d : -f 5
fi | sed 's/,.*//'  # 「,」的後面把它丟掉

