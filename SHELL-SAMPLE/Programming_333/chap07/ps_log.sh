#!/bin/sh

# ps_log.sh - 將ps指令的執行結果定期記錄下來
#            (使用信號的伺服器行程的例子)

PS_LOG=/tmp/ps.log

# do_start
#    開始做記錄的函數
do_start() {
    echo "=== `date`: start logging" >> $PS_LOG
    do_log=YES
}

# do_stop
#    停止做記錄的函數
do_stop() {
    echo "=== `date`: stop logging" >> $PS_LOG
    do_log=NO
}

do_log=NO

# 依據收到的信號，來決定要呼叫哪一個函數
trap do_start USR1
trap do_stop USR2

# 主迴圈
while true; do
    sleep 1
    if [ "$do_log" = "YES" ]; then
	echo >> $PS_LOG
	echo "*** `date`" >> $PS_LOG
	ps x >> $PS_LOG
	#ps -a >> $PS_LOG  # Solaris
    fi
done
