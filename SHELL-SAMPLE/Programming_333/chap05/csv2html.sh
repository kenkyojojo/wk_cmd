#!/bin/sh

# csv2html.sh - 將CSV檔案轉成HTML的表

# 調查是否可以使用read -r
if echo | read -r 2>/dev/null; then
    READ_R="-r"
else
    READ_R=""
fi

# 若引數的數量不正確的話，則顯示使用說明
if [ $# -ne 1 ]; then
    echo "usage: cvs2html.sh csvfile"
    exit 1
fi

# 在變數LF代入換行文字
LF='
'

echo '<TABLE>'

# 只有在執行read指令的時候，IFS=換行文字
while IFS="$LF" read $READ_R record; do
    echo '<TR>'
    IFS=','
    set -- $record  # 用「,」來分解
    for col do     # 對$1, $2...都做同樣的動作
	echo "<TD>$col</TD>"
    done
    echo '</TR>'
done < "$1"

echo '</TABLE>'
