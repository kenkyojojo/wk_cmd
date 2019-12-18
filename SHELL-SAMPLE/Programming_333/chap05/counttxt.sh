#!/bin/sh

# counttext.sh - 計算目前資料夾中有幾個.txt檔

# (註)通常只要使用「ls *.txt | wc -l」即可

count=0
for fname in *; do
    ext=`expr "$fname" : '.*\(\..*\)'`
    if [ "$ext" = ".txt" ]; then
	count=`expr $count + 1`
    fi
done
echo $count
