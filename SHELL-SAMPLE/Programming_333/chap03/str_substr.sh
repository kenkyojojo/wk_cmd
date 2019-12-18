#!/bin/sh

# str_substr.sh - 取出字串的一部分

# 取出「ABCDEFGHIJ」的第三個字到第七個字
str="ABCDEFGHIJ"
start=3
end=7
substr=`echo "$str" | cut -c${start}-${end}`
echo "$substr"
