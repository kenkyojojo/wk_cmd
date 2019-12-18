#!/bin/sh

# group_add.sh - 新增群組

# 初始設定
MIN_GID=1000
MAX_GID=60000

# show_usage
#     顯示使用方法的函數
show_usage() {
    echo 'usage: group_add.sh [-g gid] group'
    exit 1
}

# 解析命令列選項
gid=''
while getopts 'g:' flag; do
    case "$flag" in
	g)
	    gid=$OPTARG
	    ;;
	*)
	    show_usage
	    ;;
    esac
done
shift `expr $OPTIND - 1`
[ -z "$1" ] && show_usage
group="$1"

# 讀入/etc/group，決定新的群組ID
# 檢查群組名是否有重複
# (若是使用「-g」來指定的話，必須檢查是否有重複)

# 若對while...done做重新導向的話，迴圈整體會是在sub shell下被執行
# 在Solairs的(傳統的) /bin/sh下面，sub shell內的
# exit只會結束sub shell，所以無法出現正常結果。
# 若使用exec來做重新導向的話，則會在current shell中執行，所以沒問題

newgid=$MIN_GID
exec 3<&0 </etc/group
while read entry; do
    echo "$entry" | grep '^#' >/dev/null && continue  # ȹԤɤФ
    
    # 將entry分割為多個欄位
    # 若密碼欄位為空值，為了可以讓set可以正常做切割
    # 填入「x」
    IFS=":"
    set -- `echo "$entry" | sed 's/::/:x:/g'`
    IFS="$_IFS"
    n=$1
    i=$3

    # 檢查群組是否有重複
    if [ "$n" = "$group" ]; then
	echo "Group $group already exists."
	exit 1
    fi

    # 檢查群組ID
    if [ -z "$gid" ]; then
	[ $i -lt $MAX_GID -a $i -gt $newgid ] && newgid=`expr $i + 1`
    else
	if [ $gid -eq $i ]; then
	    echo "Gid $gid already exists."
	    exit 1
	fi
    fi
done
exec 0<&3
[ -z "$gid" ] && gid=$newgid

# 在/etc/group中新增entry
echo "$group:x:$gid:" >>/etc/group
echo "Group $group, gid $gid has been created."
exit 0
