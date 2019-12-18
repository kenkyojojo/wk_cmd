#!/bin/sh

## command.sh - 優先呼叫內建指令

##
## 請注意! 本程式不會有正常結果
##

## 正確的使用範例
cd() {                                # 定義函數cd
    echo "New current directory: $1"
    command cd $1                     # 呼叫內建的cd
}

## 錯誤的使用範例
pwd() {                               # 定義函數pwd
    echo -n "Current directory: "
    #echo "Current directory: \c"     # Solaris的情況
    pwd                   # 呼叫的不是內建的pwd，而是這個函數本身
}                         # 它會一直呼叫自己，直到出現錯誤為止

cd /
pwd
