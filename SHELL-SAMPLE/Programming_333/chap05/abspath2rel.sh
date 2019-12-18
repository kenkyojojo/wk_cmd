#!/bin/sh

# abspath2rel.sh - 將絕對路徑轉成相對路徑

# 若$1中是空值(也就是沒有任何的引數)的話，則顯示使用說明
if [ -z "$1" ]; then
    echo "usage: abspath2rel.sh abs_path"
    exit 1
fi

# 檢查引數是否從「/」開始(是否為絕對路徑)。
# 若在expr的引數中指定「/」一個字的話，則會被看成是除法符號而發生錯誤，
# 所以在前面加上一個多餘的字「x」。
if [ `expr x"$1" : x'/'` -eq 0 ]; then
    # 因為引數是相對路徑，所以發生錯誤
    echo "$1: not an absolute path"
    exit 1
fi

org=`expr x"$PWD" : x'/\(.*\)'`  # 基準資料夾(前面的「/」除掉)
abs=`expr x"$1"   : x'/\(.*\)'`  # 絕對路徑(前面的「/」除掉)
rel="."                          # 相對路徑
org1=""
abs1=""

# 從前面做檢查，把共通的部分刪掉
while true; do
    
    # 把基準資料夾、絕對路徑的第一個要素取出
    org1=`expr x"$org" : x'\([^/]*\)'`
    abs1=`expr x"$abs" : x'\([^/]*\)'`

    # 若不相同的話，則結束迴圈
    [ "$org1" != "$abs1" ] && break

    # 把第一個要素丟掉
    org=`expr x"$org" : x'[^/]*/\(.*\)'`
    abs=`expr x"$abs" : x'[^/]*/\(.*\)'`

done

if [ -n "$org" ]; then  # 基準資料夾的要素還有剩下的情況
    _IFS="$IFS"; IFS='/'
    for c in $org; do   # 回溯必要的份量
	rel="$rel/.."
    done
    IFS="$_IFS"
fi

if [ -n "$abs" ]; then  # 絕對路徑的要素還有剩下的話
    rel="$rel/$abs"     # 加到相對路徑上
fi

rel=`expr x"$rel" : x'\./\(.*\)'`  # 把前頭的「./」去掉
echo "$rel"
