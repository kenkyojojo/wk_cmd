#!/bin/sh

# fqdn.sh - 取得主機的FQDN(完全修飾網域名稱)

_IFS="$IFS"
DOMAIN_ONLY=NO

# 使用「-d」選項使其只顯示網域名稱(不顯示主機名稱)
[ "$1" = "-d" ] && DOMAIN_ONLY=YES

# 將hostname指令的結果用「.」做區隔，設定到引數清單去
host=`hostname`
IFS="."
set -- $host
IFS="$_IFS"

# 若$#(引數的個數)為1的話，表示hostname指令的結果只有主機名稱
# (也就是不包含網域名稱)
if [ $# -eq 1 ]; then
    # 若hostname只傳回主機名稱的話，從/etc/resolv.conf中的
    # 「domain DOMAIN」取得網域名稱
    host=$1
    set -- `grep '^domain[ \t]' /etc/resolv.conf`
    domain=$2
else
    # hostname傳回FQDN時
    host=$1
    shift
    IFS="."
    domain="$*"
    IFS="$_IFS"
fi

# 顯示結果
if [ $DOMAIN_ONLY = YES ]; then
    echo "$domain"
else
    echo "$host.$domain"
fi
