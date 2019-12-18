#!/bin/sh

# isnum.sh - 調查字串是否為整數

# is_num STR
#     調查STR是否為整數，並顯示訊息
is_num() {
    [ "$1" -eq 0 ] 2>/dev/null
    if [ $? -ge 2 ]; then
	echo "$1 is NOT a valid integer."
    else
	echo "$1 is a valid integer."
    fi
}

# 呼叫is_num看看
is_num "256"
is_num "-32"
is_num "X64"
