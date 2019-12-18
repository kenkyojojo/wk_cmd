#!/bin/bash

# array_bash_allelem.sh - 取得bash的陣列變數的所有要素

# 製作陣列變數
array=(one two three four)

# 將所有的變數用「:」連起來並顯示
IFS=':'
echo "${array[*]}"

# 將所有的要數用換行文字連起來並顯示(=每一行顯示一個要素)
IFS=$'\n'  # 換行文字
echo "${array[*]}"
