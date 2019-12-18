#!/bin/sh

# ctrl_case.sh - case的例子

echo "Enter yes or no."
read yesno  # 從標準輸入讀入一行內容，代入到變數yesno中
case "$yesno" in
    y*|Y*)  # 表y或Y開頭的所有字串
	echo "Your answer is YES."
	;;
    [nN]*)  # 表n或N開頭的所有字串
	echo "Your answer is NO."
	;;
    *)      # 以上皆不符合的情況
	echo "Your answer is ambigous."
esac
