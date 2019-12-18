#!/bin/sh

# str_fieldsplit.sh - 將字串分割成幾個單字

# 對象字串
text="field1,field2,field3,field4,field5"

_IFS="$IFS"   # 先把IFS的內容存起來
IFS=','       # 將區隔文字設為「,」
set -- $text  # 分割:結果會被放到$1,...$9內
IFS="$_IFS"   # 將IFS的內容復原

# 顯示結果
echo "$2"
echo "$4"
