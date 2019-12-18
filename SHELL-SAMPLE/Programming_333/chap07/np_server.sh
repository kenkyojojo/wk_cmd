#!/bin/sh

# np_server.sh - 使用FIFO的伺服器行程

# 初始設定
PIPE=/tmp/np_server.pipe
SVER=1

# cleanup
#     結束時將FIFO刪除
cleanup() {
    echo "cleanup" >&2
    [ -p $PIPE ] && rm $PIPE
    exit
}

# 若FIFO已存在，則顯示錯誤並結束
if [ -e $PIPE ]; then
    echo "Named pipe $PIPE already exist."
    echo "If it is sure that server is not running,"
    echo "remove it manually and restart server."
    exit 1
fi

# 製作FIFO
trap cleanup INT TERM
mkfifo -m 600 $PIPE

# 讀入用戶端送出的指令
while true; do
    read command <$PIPE
    set -- $command
    case $1 in
	WCNT) # 計算單字數量
	    echo 0 `expr $# - 1` >>$PIPE
	    ;;
	SVER) # 傳回伺服器的版本
	    echo 0 $SVER >>$PIPE
	    ;;
	*)    # 其它的指令都視為錯誤
	    echo 1 "Unknown command" >>$PIPE
    esac
done
