#!/bin/sh

# pager.sh - 當沒有指定檔名的時候
#            顯示選擇檔案用的對話盒

if [ -z "$1" ]; then
    tmp=`mktemp /tmp/dialog.XXXXXXXX` || exit 1
    dialog --fselect ./ 12 60 2>"$tmp" || { rm "$tmp"; exit 1; }
    fname=`cat "$tmp"`
    rm "$tmp"
else
    fname="$1"
fi

${PAGER:-more} "$fname"
