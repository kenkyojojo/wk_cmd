#!/bin/bash
# ↑為了讓bash的擴充功能為有效，用/bin/bash呼叫

# lsdiff.sh - 「<(command)」的例子

# 若引數的數目不是兩個的話，則顯示錯誤訊息並終止
if [ "$#" -ne 2 ]; then
    echo "usage: lsdiff DIR1 DIR2"
    exit 1
fi

# 用diff來比較兩個資料夾的內容
# (「tput cols」是傳回使用中的終端的寬度)
diff -y --width=`tput cols` <( ls "$1" ) <( ls "$2" )
#diff <( ls "$1" ) <( ls "$2" )  # Solaris的diff是不能使用-y選項的。
