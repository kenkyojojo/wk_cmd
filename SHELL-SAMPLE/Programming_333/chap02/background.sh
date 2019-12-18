#!/bin/sh

# background.sh - 將指令或函數在背景執行

# 定義函數
bgfunc() {
    for i in 1 2 3 4 5; do  # 迴圈1(每隔1秒顯示1、2、3、4、5)
	echo $i
	sleep 1
    done
}

bgfunc &   # 將bgfunc在背景執行
for j in A B C D E; do      # 迴圈2(每隔1秒顯示A、B、C、D、E)
    echo $j
    sleep 1
done
