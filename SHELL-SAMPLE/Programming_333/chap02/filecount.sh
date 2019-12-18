#!/bin/sh

# filecount.sh - 統計檔案的個數

# 統計出指定的資料夾底下
# 所有的檔案．資料夾的個數，並回報之

do_list() {
    # 這個函數是做遞迴處理(自己呼叫自己)的，所以將變數宣告為區域變數
    local dir count
    dir="$1"
    count=0

    #對於使用「${dir}/*」之後顯示出來的所有檔案．資料夾做同樣的處理
    for fn in ${dir}/*; do
	if [ -d "$fn" ]; then   #若是資料夾的話，做遞迴呼叫
	    do_list "${fn}"
	fi
	count=`expr $count + 1` #統計檔案的個數
    done
    echo "${count} ${dir}"
}

do_list $1
