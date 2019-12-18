#!/bin/sh

# kcode.sh - 判別漢字碼，並顯示之

# 只讀入輸入檔的前10行。若輸入檔並未被指定的話
# 則從標準輸入讀取(/dev/fd/0)
src=`head "${1:-/dev/fd/0}"`
kcode="(unknown)"

# 轉換成各種文字碼看看，若和原本的沒有變化
# 則表示其為正確的文字碼
for guess in "-w UTF-8" "-e EUC-JP" "-s Shift-JIS" "-j JIS"; do
    set -- $guess  # $1=選項 $2=文字碼名稱
    out=`echo "$src" | nkf $1`
    if [ "$src" = "$out" ]; then
	kcode=$2
	break;
    fi
done

echo "$kcode"
