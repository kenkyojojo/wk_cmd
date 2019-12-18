#!/bin/sh

# file_to_var.sh - 將檔案的內容寫入到變數

# 將file.out的內容寫入到變數msg
msg=`cat file.out`
echo "$msg"
