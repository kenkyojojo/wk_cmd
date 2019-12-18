#!/bin/sh

# func_retval.sh - 從函數傳回結果

# 函數dayofweek會把今天星期幾用英文來傳回
dayofweek() {
    LANG=C date +%A
}

# 函數issunday會在若今天是星期天的話傳回終止碼0(表成功)
# 在其它狀況中傳回1(表失敗)
issunday() {
    if [ `dayofweek` = "Sunday" ]; then
	return 0
    else
	return 1
    fi
}

# 顯示今天星期幾
dow=`dayofweek`  # 將dayofweek的輸出代入到變數dow中
echo "Today is $dow"

# 若今天是星期天的話，則顯示訊息
# (「&&」會在前面的指令執行成功之後，才去執行後面的指令)
issunday && echo "Have a nice holiday!"
