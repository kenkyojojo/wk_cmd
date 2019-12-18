#!/bin/sh

# var_to_file.sh - 把變數的內容寫到檔案中

# file.out中會寫入變數msg的內容
msg='Where do you want to go today?'
echo "$msg" > file.out
