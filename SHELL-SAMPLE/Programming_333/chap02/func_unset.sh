#!/bin/sh

# func_unset.sh - 取消已定義的函數

# 定義函數
myfunc() {
    echo "Hmm, this function is no longer useful."
}

unset myfunc  # 將已定義的函數取消
myfunc        # 呼叫(因為已被取消，所以會發生錯誤)
