#!/bin/sh

# str_compare.sh - 比對字串

# 比對用的字串
str1="foo"
str2=""

# 「[」指令會傳回與比較結果相應的終止碼
[ "$str1" = "foo" ];  echo $?
[ "$str1" != "foo" ]; echo $?

# 使用if敘述，進行相對應的處理
if [ "$str1" = "foo" ]; then
    echo '$str1 is foo'
else
    echo '$str1 is not foo'
fi

# 也可以寫成這樣
[ -z "$str2" ] && echo '$str2 is empty' || echo '$str2 is not empty'

# 其它比較複雜的條件寫法
[ "$str1" = "foo" -a -z "$str2" ] && echo '$str1 is foo AND $str2 is empty'
[ "$str1" = "bar" -o -z "$str2" ] && echo '$str1 is bar OR $str2 is empty'
