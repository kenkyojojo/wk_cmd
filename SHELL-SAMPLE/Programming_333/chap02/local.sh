#!/bin/sh

# local.sh - 區域變數的例子

##
## 不使用區域變數的例子
##

# 由於函數裡面和呼叫者都是使用同樣名稱的變數name，
# 所以執行結果和原本想要的結果不同。
osname_global() {
    name=`uname -s`
    echo "OS name: $name"
}
name=`whoami`
osname_global  # 變數name的內容會被改變
echo "User name: $name"


##
## 使用區域變數的例子
##

# 由於在函數裡面把變數name宣告為區域變數
# 因此和呼叫者的變數name之間不會互相干涉
osname_local() {
    local name
    name=`uname -s`
    echo "OS name: $name"
}
name=`whoami`
osname_local
echo "User name: $name"
