#!/bin/sh

# ctrl_if.sh - 使用if的例子

# 「tty -s」在標準輸入為終端的時候，傳回終止碼0。若不是終端的話，則傳回非0值
# 
if tty -s; then
    # 在終端中執行
    echo "I'm running on a terminal."
else
    # 標準輸入被重新導向，或有使用pipe
    echo "Hmm, standard input is piped or redirected."
fi
