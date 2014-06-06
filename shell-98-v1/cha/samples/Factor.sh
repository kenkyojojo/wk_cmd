#! /bin/bash
#
# function 也可以使用遞迴功能
# 以下是數學階乘的計算, 如 5! = 5 * 4 * 3 * 2 * 1
#

function factor_in () {
    local tmp
    local tmp1
    tmp="$1"

    if [ $tmp -eq 1 ]; then
	   echo -n " 1 "
	   r=1
    else
	   echo -n " $tmp * "
	   tmp1=$tmp
	   tmp=$(($tmp-1))
	   factor_in $tmp
	   r=$(($tmp1 *  $r))
    fi
}

if [ $# -ne 1 ]; then
    echo "使用法: $0 正整數"
    exit 1
fi

echo
echo -n $1"! = "
factor_in $1
echo -n "= $r"
echo
