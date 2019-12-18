#!/bin/sh

# metachar.sh - 中介字元的使用方法

# showargs
#    顯示引數的個數與一覽表
showargs() {
    echo "Number of args: $#"
    echo "List of args:"
    for arg in "$@"; do    # 對所有的引數都做同樣的處理
	echo "  $arg"
    done
}

# 定義適當的變數
meta='<VARIABLE>'

# 在第2個例子裡面，「$meta」會被展開，並會被空白字元分割為不同單字
echo "*** Example 1 ***"
showargs word\ contains\ spaces\ with\ \$meta\ character
showargs words separated by spaces, without $meta character

# 在第2個例子裡面，「$meta」和「`date」會被展開
echo "*** Example 2 ***"
showargs "Quoted \"string\" with \$meta character: \`date\`"
showargs "Without $meta chacacter: `date`"

# 中介字元的功能會隨上下文而不同的例子
echo "*** Example 3 ***"
showargs Single-Quote-\' "Single-Quote-\'"
