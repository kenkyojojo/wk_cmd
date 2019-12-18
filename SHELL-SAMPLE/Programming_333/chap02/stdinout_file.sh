#!/bin/sh

# stdinout_file.sh - 表示標準輸入輸出的檔名的例子

# 在本例中，sort會從/dev/fd/0(標準輸入)取得資料，
# 將結果寫到/dev/fd/1(標準輸出)中。也就是和「cat $0 | sort」是一樣意思。
# $0是表示script file自己本身的檔名。

cat $0 | sort -o /dev/fd/1 /dev/fd/0
