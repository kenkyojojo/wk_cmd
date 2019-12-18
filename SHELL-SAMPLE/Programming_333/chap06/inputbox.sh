#!/bin/sh

# inputbox.sh - 從純文字對話盒取得1行輸入

tmp=`mktemp /tmp/dialog.XXXXXXXX` || exit 1
dialog --inputbox "May I have your name, please?" 8 70 "Anonymous Coward" 2>"$tmp"
dialog --msgbox "Your name is `cat "$tmp"`" 8 70
rm "$tmp"
