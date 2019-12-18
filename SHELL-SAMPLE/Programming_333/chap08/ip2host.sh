#!/bin/sh

# ip2host.sh - 從IP位址調查主機名稱

# r_host
#     使用host指令來調查主機名稱
#     結果的最後一個單字就是主機名稱
r_host() {
    set -- `host $1`
    shift `expr $# - 1`
    case $1 in
	*\(NXDOMAIN\))  # 找不到時
	    return 1 ;;
	*)
	    expr "$1" : "\(.*\)\."  #主機名稱最後的「.」要拿掉
    esac
}

# r_nslookup
#     使用nslookup來調查主機名稱
#     找出有「Name: HOSTNAME」的那一行，取出HOSTNAME
r_nslookup() {
    set -- `/usr/sbin/nslookup $1 2>/dev/null | grep '^Name:'`
    if [ -n "$2" ]; then
	echo $2
    else
	return 1
    fi
}

# 若是Solaris的話，使用nslookup，若是其它系統的話則使用host指令
# 從主機名稱調查IP位址
case `uname` in
    SunOS)
	RESOLVER=r_nslookup ;;
    *)
	RESOLVER=r_host
esac
$RESOLVER $1
