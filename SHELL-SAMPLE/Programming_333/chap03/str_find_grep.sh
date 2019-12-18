#!/bin/sh

# str_find_grep.sh - 用grep來搜尋字串

# 搜尋用的字串
text="The quick brown fox jumps over the lazy dog."

# 搜尋text中是否含有「fox」字串
if echo "$text" | grep -q 'fox'; then
    echo "found"
else
    echo "not found"
fi
