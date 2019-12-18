#!/bin/sh

# dir_exist.sh - 調查資料夾是否存在

if [ -d "$1" ]; then
    echo "$1 exists"
else
    echo "$1 does not exist"
fi
