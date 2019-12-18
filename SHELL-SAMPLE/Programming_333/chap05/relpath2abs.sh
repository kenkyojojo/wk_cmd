#!/bin/sh

# relpath2abs.sh - 將相對路徑變成絕對路徑

# 若$1為空值的話，(即沒有任何引數)，則顯示使用說明
if [ -z "$1" ]; then
    echo "usage: relpath2abs.sh path"
    exit 1
fi

# 檢查引數是否以「/」為起頭(也就是是否為絕對路徑)。
# 若在expr的引數中指定「/」一個字的話，則會被看成除法的運算符號而發生錯誤
# 所以在前面放了一個多餘的文字「x」
if [ `expr x"$1" : x'/'` -ne 0 ]; then
    rel="$1"       # 引數是絕對路徑(若含有「..」的話再做處理)
else
    rel="$PWD/$1"  # 引數為相對路徑
fi

abs="/"
IFS='/'  # 將單字用「/」來分割
for comp in $rel; do  # 對相對路徑的要素做重複的動作
    case "$comp" in
	'.'|'')  # 「/./」「//」→「/」
	    continue
	    ;;
	'..')    # 若是「..」的話，則去掉絕對路行的最後的要素
	    abs=`dirname "$abs"`
	    ;;
	*)       # 其它情況的話，則將要素追加到絕對路徑的最後
	    [ "$abs" = "/" ] && abs="/$comp" || abs="$abs/$comp"
	    ;;
    esac
done

echo "$abs"  # ̤ɽ
