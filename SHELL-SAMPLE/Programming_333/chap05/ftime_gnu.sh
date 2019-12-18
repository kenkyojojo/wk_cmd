#!/bin/sh

# ftime_gnu.sh - 調查檔案的更新日期(Linux篇)

# 將ls的輸出分割為多個單字
set -- `ls -l -d --full-time "$1"`

shift 5  # 因為項目數很多，所以先做shift

# 分解結果
# $1 - 星期幾
# $2 - 月
# $3 - 日
# $4 - 時:分:秒
# $5 - 年

# 顯示結果
month=`printf '%02d' $2`  # 01-12
day=`printf '%02d' $3`    # 01-31
echo "$5/$month/$day $4"
