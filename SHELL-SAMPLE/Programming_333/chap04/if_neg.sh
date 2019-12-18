#!/bin/sh

# if_neg.sh - 使if文的條件逆轉

# true指令會永遠傳回值(終止碼=0)
if ! true; then
    echo true
else
    echo false
fi
