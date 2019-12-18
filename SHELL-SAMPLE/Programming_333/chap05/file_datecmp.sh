#!/bin/sh

# file_datecmp.sh - 比較檔案的新舊

# 若內建的「test -e」不能使用時，則使用外部指令
if /bin/sh -c 'test -e "$0"' 2>/dev/null; then
    command=""         # Solaris以外的情況
else
    command="command"  # Solaris的情況
fi

# 若指定的引數的數量不對的話，則顯示使用說明
if [ $# -ne 2 ]; then
    echo "usage: file_datecmp.sh file1 file2"
    exit 1
fi

# 確定比較對象檔案存在
$command [ -e "$1" ] || { echo "$1 does not exist"; exit 1; }
$command [ -e "$2" ] || { echo "$2 does not exist"; exit 1; }

# 比較新舊，並顯示結果
if $command [ "$1" -nt "$2" ]; then
    echo "$1 is newer than $2"
elif $command [ "$1" -ot "$2" ]; then
    echo "$1 is older than $2"
else
    echo "$1 and $2 have exactly the same timestamp."
fi
