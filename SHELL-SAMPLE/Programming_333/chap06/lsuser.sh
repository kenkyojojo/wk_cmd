#!/bin/sh

# lsuser.sh - 顯示已登錄到系統中的使用者一覽表

# 將換行文字代入到變數LF中
LF='
'

# 若標準輸出是終端的話，則讓分段表示法變成預設狀態
if test -t 1; then
    column=YES
else
    column=NO
fi

# 分段表示法的ON/OFF可以用選項來指定之
while getopts 1Ch flag; do
    case $flag in
	1)
	    column=NO ;;
	C)
	    column=YES ;;
	h)
	    echo "usage: lsuser.sh -1Ch"
	    exit 1 ;;
	*)
	    exit 1
    esac
done

# Darwin (Mac OS X)中，不使用/etc/passwd。
if [ `uname` = "Darwin" ]; then
    show_passwd_db="nidump passwd ."
else
    show_passwd_db="cat /etc/passwd"
fi

# column是讓輸入變成分段表示法的指令。
# 很遺憾地，在Solaris中不能使用。
filter="cat"
if [ "$column" = "YES" ]; then
    if expr "x`which column`" : "x/" >/dev/null; then
	filter="column"
    else
	echo "Warning: This system does not have column command." >&2
    fi
fi

# 顯示結果
IFS="$LF"
for record in `eval "$show_passwd_db"`; do
    IFS=':'
    set -- $record
    echo "$1"
done | $filter
