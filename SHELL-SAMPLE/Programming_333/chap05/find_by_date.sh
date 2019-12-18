#!/bin/sh

# find_by_date.sh - 搜尋出在指定的時日被更新的檔案

# 若GNU date有被安裝為gnudate的話，則使用之
gnudate=`which gnudate`
[ -z "$gnudate" ] && gnudate="date"

# cleanup
#     若script被中斷．結束時，則會執行這個函數
cleanup() {
    [ -n "$start_tmp" ] && rm "$start_tmp"
    [ -n "$end_tmp"   ] && rm "$end_tmp"
}

# 若引數的數目不對的話，則顯示使用說明
if [ $# -ne 2 ]; then
    echo "usage: find_by_date.sh dir date"
    exit 1
fi

# 設定引數的值
dir="$1"
start_date=`$gnudate -d "$2" +%Y%m%d`0000      # 指定的日期
end_date=`$gnudate -d "1 day $2" +%Y%m%d`0000  # 指定的日期+1

# 設定成在中斷．結束時，執行cleanup函數
trap cleanup EXIT
trap exit INT      # 使用Solaris的/bin/sh時需要用到

# 製作做為日期之基準點的暫存檔
start_tmp=`mktemp /tmp/fbd.XXXXXXXX` || exit 1
end_tmp=`mktemp /tmp/fbd.XXXXXXXX`   || exit 1
touch -t $start_date $start_tmp
touch -t $end_date   $end_tmp

# 找出比「日期」更新，而比「日期+1」更舊的檔案
find "$dir" -newer $start_tmp -not -newer $end_tmp
