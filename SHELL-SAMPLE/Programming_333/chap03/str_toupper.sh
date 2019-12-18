#!/bin/sh

# str_toupper.sh - 將字串換成大寫

# 欲處理的字串
text="The quick brown fox jumps over the lazy dog."

# 將text中的小寫字換成大寫
result=`echo "$text" | tr 'a-z' 'A-Z'`
echo "$result"
