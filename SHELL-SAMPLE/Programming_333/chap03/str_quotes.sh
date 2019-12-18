#!/bin/sh

# str_quotes.sh - 引號的不同用法

# 顯示引數的數量以及一覽表
showargs() {
    echo "Number of args: $#"
    echo "List of args:"
    for arg in "$@"; do    # 對所有的引數做重複的動作
	echo "  $arg"
    done
}

# 在testvar中代入一個含有空白字元的字串
testvar="abc def ghi"

# 使用「"$testvar"」的情況
echo "*** Quoted by \"...\" ****"
showargs "$testvar"

# 使用「'$testvar'」的情況(變數不會被展開)
echo "*** Quoted by '...'  ***"
showargs '$testvar'

# 使用「$testvar」的情況(單字會被空白字元分割)
echo "*** Not quoted ***"
showargs $testvar
