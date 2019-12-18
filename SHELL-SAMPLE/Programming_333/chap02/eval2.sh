#!/bin/sh

# eval2.sh - 將指令的輸出結果當成script來執行

# 下面的兩行內容會被執行
## echo "Implanted code was executed!"
## foo="BAR"

# 從這個script本身找到「## 」開頭的行，然後將行頭的「##」拿掉之後顯示之。
# $0是表這個script的檔名
grep '^## ' $0 | sed 's/^## //'
echo "---"

# 將同樣的東西重新導向到sh之後再執行
grep '^## ' $0 | sed 's/^## //' | sh
echo "foo=$foo"  # foo裡面沒有東西

# 這次換使用eval來執行
eval "`grep '^## ' $0 | sed 's/^## //'`"
echo "foo=$foo"  # foo裡面有設定東西
