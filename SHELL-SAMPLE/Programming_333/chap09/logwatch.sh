#!/bin/sh

# logwatch.sh - 監視系統記錄檔

# 依據系統的記錄檔的位置做改寫
LOGFILE=/var/log/system.log

# 用「tail -f」將記錄檔中新增的部分依序輸出
tail -f -n0 "$LOGFILE" | while read line; do
    # 檢查cron的記錄檔
    # 因為在Solaris裡面，記錄檔的儲存位置、格式都不同，所以不會運作
    program=`expr "$line" : '.*(\(.*\))'`
    if [ -n "$program" ]; then
	printf "%s was executed by cron.\a\n" "$program"
    fi
done
