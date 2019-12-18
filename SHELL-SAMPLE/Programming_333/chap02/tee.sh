#!/bin/sh

# tee.sh - tee指令的使用例

# 將ls的輸出寫入到list.txt
# 並將逆向排序的結果寫入到list_rev.txt中
ls | tee list.txt | sort -r > list_rev.txt
