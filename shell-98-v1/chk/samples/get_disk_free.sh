#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

declare -i TOTAL

#
# 函式區
#

get_usedTotal() {
	TOTAL=$(df -B 1024K | grep ${p}$ | awk '{print $3}')
	echo "已使用的空間大小: $TOTAL MB."
}

get_avaibleTotal() {
	TOTAL=$(df -B 1024K | grep ${p}$ | awk '{print $4}')
	echo "剩餘可用的空間大小: $TOTAL MB."
}

#
# 主程式區
#

p=${1:?'請提供分割區的掛載點的名稱. 比如: / 或 /home 或 /var'}
if [[ ! $p == /* ]]; then
   p=/$p
fi  

get_usedTotal $1
get_avaibleTotal $1
