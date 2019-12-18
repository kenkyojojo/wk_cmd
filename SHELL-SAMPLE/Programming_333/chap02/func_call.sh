#!/bin/sh

# func_call.sh - 函數呼叫的例子

# 定義函數
today() {
    date +'%Y/%m/%d'
}

# 呼叫函數
today > today.txt   # 也可以做重新導向
