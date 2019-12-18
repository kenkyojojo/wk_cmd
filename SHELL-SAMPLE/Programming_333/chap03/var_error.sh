#!/bin/sh

# var_error.sh - 變數未被定義時出現錯誤

# 在這裡寫入您的名字
yourname=

# 若yourname是空值的話，則會出現錯誤
echo "Good evening, ${yourname:?Please edit var_error.sh!}!"
