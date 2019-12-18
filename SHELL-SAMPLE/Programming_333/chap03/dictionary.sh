#!/bin/sh

# dictionary.sh - 使用hash

# dict_put
#     將值設定到辭典中
# $1 - 辭典名稱
# $2 - key
# $3 - 值
dict_put() {
    eval "$1_$2=\"\$3\""
}

# dict_get
#     取出辭典中的值
# $1 - 辭典名稱
# $2 - key
dict_get() {
    eval "echo \${$1_$2}"
}

# dict_count
#     計算辭典中的項目數
# $1 - 辭典名稱
dict_count() {
    set | grep "^$1_[0-9a-zA-Z]*=" | wc -l
}

# dict_keys
#     傳回辭典的key的一覽表
# $1 - 辭典名稱
dict_keys() {
    set | grep "^$1_[0-9a-zA-Z]*=" | sed -e 's/^.*_//' -e 's/=.*$//'
}

# 將值設定到辭典中
dict_put capital "Japan" "Tokyo"
dict_put capital "US" "Washington"
dict_put capital "China" "Beijing"
dict_put capital "France" "Paris"

# 對所有的項目做重複的動作
for k in `dict_keys capital`; do
    item=`dict_get capital "$k"`
    echo "The capital of $k is $item"
done

# 計算項目數
echo "Count: `dict_count capital`"
