#!/bin/sh

# str_wordsplit.sh - 取出字串的任意單字

# 將變數text的內容分割為幾個單字，將各單字設定到 $1,$2 ... 當中
text='Your nature demands love and your happiness depends on it.'
set -- $text

# 顯示結果
echo "Number of words: $#"
echo "The fourth word: $4"
