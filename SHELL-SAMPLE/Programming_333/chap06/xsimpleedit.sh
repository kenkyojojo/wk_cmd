#!/bin/sh

# xsimpleedit.sh - 簡單的文字編輯器

# 啟動時需指定欲編輯的檔名。選擇「OK」之後，會在經過使用者的同意之後
# 將檔案儲存起來。若按下「Cancel」
# 則會在未儲存的情況下結束程式

if ! [ -f "$1" ]; then
    echo "usage: xsimpleedit.sh filename"
    exit 1
fi

tmp=`mktemp /tmp/xdialog.XXXXXXXX` || exit 1
if Xdialog --editbox "$1" 25 80 2>"$tmp"; then
    if Xdialog --yesno "Are you sure to overwrite '$1'?" 0 0; then
	cp "$tmp" "$1"
    fi
fi
rm "$tmp"
