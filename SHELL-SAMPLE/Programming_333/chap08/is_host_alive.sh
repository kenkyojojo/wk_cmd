#!/bin/sh

# is_host_alive.sh - 使用ping來調查指定的主機是否還活著

# Solaris以外系統中的ping的使用法
PING="ping"
PING_OPT="-c 1"
PING_ALIVE=' 0%'

# Solaris的話，ping的使用方法有些不同
if [ -x /usr/sbin/ping ]; then
    PING="/usr/sbin/ping"
    PING_OPT=""
    PING_ALIVE='alive'
fi

# Solaris中的話「... is alive」
# 其它系統的話「..., 0% packet loss」表示指定的主機還活著
$PING $PING_OPT $1 | grep -q "$PING_ALIVE"

# 從grep的終止碼來判斷指定的主機情況
if [ $? -eq 0 ]; then
    echo $1 is alive
    exit 0
else
    echo $1 is not alive
    exit 1
fi
