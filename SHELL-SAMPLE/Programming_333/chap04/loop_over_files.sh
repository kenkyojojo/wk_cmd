#!/bin/sh

# loop_over_files.sh - 對檔案的一覽表做重複處理

for name in "$1"/*; do
    if [ -f "$name" ]; then
	echo "$name (regular file)"
    elif [ -d "$name" ]; then
	echo "$name (directory)"
    else
	echo "$name (other type)"
    fi
done
