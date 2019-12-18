#!/bin/bash

# array_sort.sh - 對bash陣列變數的內容做排序

# 處理對象陣列
array1=('Tokyo' 'Beijing' 'Washington D.C.' 'Longon' 'Paris')

# 將換行文字設定到IFS中，用「${array[*]}」將陣列中的內容
# 逐行輸出
IFS=$'\n'

# 排序之後，將結果顯示
array2=(`echo "${array1[*]}" | sort`)
echo "${array2[*]}"
