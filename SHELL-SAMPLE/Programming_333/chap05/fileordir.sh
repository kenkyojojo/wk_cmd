#!/bin/sh

# fileordir.sh - 調查是檔案還是資料夾

# 若內建的「test -e」不能使用的話，則使用外部指令
if /bin/sh -c 'test -e "$0"' 2>/dev/null; then
    command=""         # Solaris以外的情況
else
    command="command"  # Solaris的情況
fi

# 檢查檔案是否存在+檢查其種類
if $command [ -e "$1" ]; then
    if [ -d "$1" ]; then
	echo "$1 is a directory"
    else
	echo "$1 is a file (regular or special)"
    fi
else
    echo "$1 does not exist"
fi
