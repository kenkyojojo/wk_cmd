#!/bin/bash

# arith_bash.sh - bash的四則運算

x=5
y=9
z=13

# 與expr的時候不一樣，不需將特殊符號用「\」來做脫逸(escape)
# 變數前的「$」也可以省略
a=$(( x*y ))
b=$(( (y+z)/x ))

echo "$a"
echo "$b"
