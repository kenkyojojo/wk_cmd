#!/bin/sh

# ctrl_elif.sh - elif的例子

# 取得現在時間的「時」的部分
hour=`date +%H`

# 若是4點到12點則顯示「Good morning!」
# 若是12點到17點則顯示「Good afternoon!」
# 若是17點到21點則顯示「Good evening!」
# 若是21點到隔天2點則顯示「Good night...」
# 其它時間則顯示「Don't you have to go to bed?」

if [ $hour -ge 5 -a $hour -lt 12 ]; then
    echo "Good morning!"
elif [ $hour -ge 12 -a $hour -lt 17 ]; then
    echo "Good afternoon!"
elif [ $hour -ge 17 -a $hour -lt 21 ]; then
    echo "Good evening!"
elif [ $hour -lt 2 -o $Hour -ge 21 ]; then
    echo "Good night..."
else
    echo "Hmm, it seems to be midnight. Don't you have to go to bed?"
fi
