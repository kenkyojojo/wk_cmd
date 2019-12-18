#!/bin/sh

# trap_exit.sh - trap指令的範例

# cleanup
#     結束時會被呼叫的函數
cleanup() {
    echo "Doing cleanup jobs."
    [ -n "$tmpfile" ] && rm "$tmpfile"
}

# 設定trap
trap cleanup EXIT
trap 'exit' INT  # Solaris的/bin/sh以外不需用到這一行


# 製作暫存檔
tmpfile=`mktemp /tmp/tmp.XXXXXXXX` || exit 1
echo "Press Ctrl-C to abort."

# 會花不少時間的處理
for i in one two three four five six seven eight nine ten; do
    echo $i >>"$tmpfile"
    sleep 1
done

# 顯示暫存檔的內容
cat "$tmpfile"
