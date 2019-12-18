#!/bin/sh

# loop_over_cmd.sh - 對指令的輸出做重複處理

# 處理對象資料夾
dir="$1"

# 將區隔文字指定為換行字元
IFS='
'

# ls指令會在標準輸出不是終端的時候，將檔案逐行輸出。
# 由於IFS裡面只有設定換行文字，所以檔名中含有空白字元
# 也無所謂。
for name in `ls "$dir"`; do
    if [ -f "$dir/$name" ]; then
	echo "$dir/$name (regular file)"
    elif [ -d "$dir/$name" ]; then
	echo "$dir/$name (directory)"
    else
	echo "$dir/$name (other type)"
    fi
done
