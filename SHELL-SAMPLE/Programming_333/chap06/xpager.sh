#!/bin/sh

# xpager.sh - 若沒有指定檔名的話，則顯示
#             選擇檔案用的對話盒

if [ -z "$1" ]; then
    fname=`Xdialog --stdout --fselect ./ 25 60` || exit 1
else
    fname="$1"
fi

Xdialog --no-cancel --textbox "$fname" 25 80
