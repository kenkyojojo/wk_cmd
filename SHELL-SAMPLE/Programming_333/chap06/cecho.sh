#!/bin/sh

# cecho.sh - 讓Solaris也可以使用「echo -n」

# 若使用「echo -n」時，會顯示「-n」的話，則重新定義echo成為一個函數
# 在其它的系統中則不做任何處理
if [ -n "`echo -n`" ]; then
    echo() {
	(  # 由於Solaris中無法使用local，所以在subshell中保護變數
	    if [ "$1" = "-n" ]; then
		shift
		postfix="\c"
	    else
		postfix=""
	    fi
	    command echo "$*$postfix"  # 執行原本的echo
	)
    }
fi

echo -n "Hello, "
echo "world!"
