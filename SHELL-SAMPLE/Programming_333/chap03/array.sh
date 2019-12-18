#!/bin/sh

# array.sh - 使用陣列

# array_put
#     將值設定到陣列中
# $1 - 變數名稱
# $2 - 編號(流水號)
# $3 - 設定的值
array_put() {
    eval "$1_$2=\"\$3\""
}

# array_get
#     取出陣列的值
# $1 - 變數名稱
# $2 - 編號(流水號)
array_get() {
    eval "echo \${$1_$2}"
}

# array_count
#     計算陣列的要素數
# $1 - 變數名稱
array_count() {
    set | grep "^$1_[0-9]*=" | wc -l
}

# 將值設定陣列中
array_put sample 0 "zero"
array_put sample 1 "one"
array_put sample 2 "two"

# 顯示各要素的值
for i in 0 1 2; do
    item=`array_get sample $i`
    echo "sample_$i='$item'"
done

# 顯示要素個數
echo "Count: `array_count sample`"
