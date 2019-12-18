#!/bin/sh

# redirect_out.sh - 重新導向(輸出)的例子

# 將訊息寫到address.txt中。「>」表覆蓋寫入，「>>」表追加寫入，
# 因此address.txt中會被存入兩行資料。
echo "In the long history of the world," >address.txt
echo "we have come to dedicate.." >>address.txt
cat address.txt

# 再使用覆蓋寫入的方法寫入資料
# 剛才那兩行內容會被消去，只存進新的這一行。
echo "I have a dream." >address.txt
cat address.txt
