#!/bin/sh

# file_exist.sh - 調查檔案是否存在

if [ -f "$1" ]; then
    echo "$1 exists"
else
    echo "$1 does not exist"
fi
