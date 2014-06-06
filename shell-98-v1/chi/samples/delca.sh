#! /bin/bash

shopt -s -o nounset

ACTfile=${1:?'錯誤! 請提供帳號檔!'}
[ ! -f "$ACTfile" ] && echo "帳號檔 $ACTfile 不存在." && exit 1

declare -i okdel=0
act=''
password=''

#
# 主程式區
#
while read act password 
do
    userdel -r $act
    if [ $? -eq 0 ]; then
       ((okdel++))
       echo "已刪除帳號 $act ...."
    fi
done < <(awk 'BEGIN{FS=":"} /\w:\w/ {print $1, $2}' $ACTfile)

echo "共刪除了 $okdel 個帳號."
