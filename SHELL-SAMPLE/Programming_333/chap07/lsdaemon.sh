#!/bin/sh

# lsdaemon.sh - 顯示daemon的執行狀況

# 將欲調查的daemon的清單用空白字元區隔指定
DAEMONS="cron crond cupsd inetd lpd named nmbd ntpd smbd sshd syslogd xinetd"

# 依OS的不同來設定ps指令的選項
if [ "`uname`" = "SunOS" ]; then
    PSCMD="ps -A -ocomm"
else
    PSCMD="ps axcww -ocommand"
fi

# 檢查各daemon的動作
for daemon in $DAEMONS; do
    # 「\<」「\>」是表與各單字的開頭、結尾符合的正規表現
    out=`$PSCMD | grep "\\<${daemon}\\>"`
    if [ -n "$out" ]; then
	status="RUNNING"
    else
	status="not found"
    fi
    printf "%-16s %s\n" "$daemon" "$status"
done
