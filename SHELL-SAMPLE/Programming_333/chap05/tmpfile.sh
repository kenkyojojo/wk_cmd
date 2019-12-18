#!/bin/sh

# tmpfile.sh - 製作暫存檔

# 製作暫存檔(若製作失敗的話則結束)
tmpfile=`mktemp /tmp/scripttmp.XXXXXXXX` || exit 1

echo "hoge hoge" >>$tmpfile  # 使用暫存檔的處理
rm $tmpfile                  # 使用結束之後刪除

# 在/tmp之外的地方製作暫存檔的例子
tmpfile=`mktemp "$HOME/tmp/scripttemp.XXXXXXXX"`|| exit 1
rm $tmpfile
