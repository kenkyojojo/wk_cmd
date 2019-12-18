#!/bin/sh

# host2ip.sh - 從主機名稱取得IP位址

# r_host
#     使用host指令來調查IP位址
#     出來的結果的最後一個單字就是IP位址
r_host() {
    set -- `host $1`
    shift `expr $# - 1`
    case $1 in
	*\(NXDOMAIN\))  #找不到時
	    return 1 ;;
	*)
	    echo $1
    esac
}

# r_nslookup
#     使用nslookup指令調查IP位址
#     「Name: HOSTNAME」的下一行會有「Address: IP_ADDRESS」
r_nslookup() {
    set -- `/usr/sbin/nslookup $1 2>/dev/null | sed -n '/^Name:/ {
n
p
}'`
    if [ -n "$2" ]; then
	echo $2
    else
	return 1
    fi
}

# 在Solaris的話，使用nslookup指令。在其它系統的話則使用host指令
# 來從主機名稱調查IP位址
case `uname` in
    SunOS)
	RESOLVER=r_nslookup ;;
    *)
	RESOLVER=r_host
esac

$RESOLVER $1
