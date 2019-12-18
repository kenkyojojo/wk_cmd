#!/bin/sh

# func_return.sh - return的例子

# return指令會在函數的途中回到呼叫處
myfunc() {
    echo "This line will be executed."
    return  # 回到呼叫處
            # 後面的指令不會被執行
    echo "This line will be ignored."
}

# 呼叫函數
myfunc
