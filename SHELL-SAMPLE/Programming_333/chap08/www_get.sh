#!/bin/sh

# www_get.sh - 使用http協定來取得檔案

CR=`printf "\r"`

# 從URL抽取出主機名稱
url="$1"
host=`expr "$1" : "http://\([^/]*\)"`

# 用sed指令，把第一個空行之前的部分（標頭部分）刪掉。
# 由於標頭送來的換行碼是CR-LF，所以空行的正規表現法應該是「^」+CR+「$」才對
# 在此不考慮送來的資料已被編碼的情況。

cat <<EOF | nc $host 80 | sed "1,/^${CR}\$/d"
GET $url HTTP/1.0

EOF
