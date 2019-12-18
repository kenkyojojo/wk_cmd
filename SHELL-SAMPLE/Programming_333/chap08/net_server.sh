#!/bin/sh

# net_server.sh - 和tcpserver組合的網路伺服器範例

echo "SAMPLE SERVER"

# 讀取用戶端送來的訊息
while read command; do
    set -- $command
    case $1 in
        DATE) # 傳回日期
            echo 0 `date +'%Y-%m-%d'`
            ;;
        TIME) # 傳回時間
            echo 0 `date +'%H:%M:%S'`
            ;;
	EXIT) # 結束連線
	    echo 0 "EXIT"
	    exit 0
	    ;;
        *)    # 其它指令則認定為錯誤
            echo 1 "Unknown command"
    esac
done
