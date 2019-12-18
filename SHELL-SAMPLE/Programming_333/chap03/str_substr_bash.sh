#!/bin/bash

# str_substr_bash.sh - 取出字串的一部分（bash）

# 取出「ABCDEFGHIJ」的第3個字到第7個字的內容
str="ABCDEFGHIJ"
start=3
end=7

# 在bash當中，是指定開始位置和要取出的長度
# 「$(( 式字 ))」是bash的功能
offset=$(( start - 1 ))        # 開始位置（0=第1個字）
length=$(( end - start + 1 ))  # 要取出的長度

# 取出字串，並顯示結果
substr=${str:offset:length}
echo "$substr"
