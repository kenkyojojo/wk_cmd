#! /bin/bash

shopt -s -o nounset

ACTfile=${1:?'錯誤! 請提供帳號檔!'}
[ ! -f "$ACTfile" ] && echo "帳號檔 $ACTfile 不存在." && exit 1

declare -i okact=0
act=''
password=''

#
# 主程式區
#
while read act password 
do
    adduser --quiet --disabled-password --gecos '' $act
    if [ $? -eq 0 ]; then
       echo "$act:$password" | chpasswd
       ((okact++))
       echo "帳號 $act 建立完成 ...."
    fi
done < <(awk 'BEGIN{FS=":"} /\w:\w/ {print $1, $2}' $ACTfile)

echo "共建立了 $okact 個帳號."

