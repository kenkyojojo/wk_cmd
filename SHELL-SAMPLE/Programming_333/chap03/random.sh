#!/bin/sh

# random.sh - 使用ruby來產生亂數

# 顯示10個亂數
for n in 1 2 3 4 5 6 7 8 9 10; do
    random=`ruby -e 'print Integer(rand()*10)+1'`
    echo -n "$random "
    #echo "$random \c"  # Solaris
done
echo
