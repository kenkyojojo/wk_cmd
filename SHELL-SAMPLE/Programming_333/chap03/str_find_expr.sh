#!/bin/sh

# str_find_expr.sh - 用expr來搜尋字串

# 搜尋用的字串
text="The quick brown fox jumps over the lazy dog."

# 搜尋字串text中是否含有「fox」
if expr "$text" : '.*fox' >/dev/null; then
    echo "fox was found!"
else
    echo "not found"
fi
