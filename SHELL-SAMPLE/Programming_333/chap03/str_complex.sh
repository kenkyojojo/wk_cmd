#!/bin/sh

# str_complex.sh - 巢狀的字串

# do_manytimes
# 	引數$1作為指令重複執行3次給矛的字串
do_manytimes() {
    for count in 1 2 3; do
	eval "$1"
    done
    echo
}

# 以各種的引數來呼叫do_manytimes
do_manytimes 'echo "Example A - $count"'     # [A] 這個OK
do_manytimes "echo \"Example B - $count\""   # [B] 這個可能不太好
do_manytimes "echo \"Example C - \$count\""  # [C] 這個OK
