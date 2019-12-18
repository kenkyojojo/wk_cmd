#!/bin/bash

# array_diff.sh - 求出陣列的差

# 處理對象
array1=('Tokyo' 'Beijing' 'Washington D.C.' 'London' 'Paris')
array2=('Paris' 'Pusan' 'London' 'Kuala Lumpur' 'Tokyo' 'Canberra')

# 將換行字元設定到IFS中，變更區隔文字
IFS=$'\n'

# 首先，求出雙方陣列中所含的內容
both=(`{ echo "${array1[*]}"; echo "${array2[*]}"; } | sort | uniq -d`)

# 從array1將重複的部分去掉，就可以取得array1中有而array2中卻沒有
# 的項目了
only1=(`{ echo "${array1[*]}"; echo "${both[*]}"; } | sort | uniq -u`)

# 顯示結果
echo "${only1[*]}"
