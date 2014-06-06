#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

HOST=${1:?'要提供主機網域名稱或 IP 才行喔!'}
FILE=${2:?'要提供要下載的網頁路徑才行喔!'}
port=80

if [[ ! $FILE == /* ]]; then
   FILE=/$FILE
fi

exec 6<>/dev/tcp/$HOST/$port

echo -e "GET $FILE HTTP/1.1" >&6
echo -e "Host: $HOST" >&6
echo -e "Connection: close\n" >&6

SaveFile=${FILE##*/}

if [ -z "$SaveFile" ]; then
   SaveFile="index.html"
fi

cat <&6 > $SaveFile

exec 6>&-
exec 6<&-
