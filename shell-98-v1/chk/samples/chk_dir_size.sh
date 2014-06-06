#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

DIR=${1:?'請提供欲檢查的路徑，比如：/var'}
if [[ ! $DIR == /* ]]; then
   DIR=/$DIR
fi 

declare -i size SIZE

# 空間用量多少以上才列出來。這裡以 MB 為單位。
SIZE=50

while read size dir
do
    if [ $size -gt $SIZE ]; then
        echo -e "$size\t\t$dir" 
    fi
done < <(find $DIR -mindepth 1 -type d -exec du -sm {} \;)
