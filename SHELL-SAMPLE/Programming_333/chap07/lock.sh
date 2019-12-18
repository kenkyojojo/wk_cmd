#!/bin/sh

# lock.sh - 使用鎖定檔(鎖定資料夾)的範例

LOCKDIR=/tmp/lock.sh.lockdir
COUNTFILE=/tmp/lock.sh.count

# count
#     讀入共有檔案，在內容加1之後寫回去
count() {
    # 若引數有指定「lock」的話，則使用鎖定資料夾
    # 來做互斥控制
    if [ "$1" = "lock" ]; then
	# 在鎖定資料夾被製作成功之前，每隔一秒做同樣的動作
	until mkdir $LOCKDIR 2>/dev/null; do
	    sleep 1
	done
    fi

    # 讀入共有檔案，加1之後儲存
    cnt=`cat $COUNTFILE`
    cnt=`expr $cnt + 1`
    echo $cnt >$COUNTFILE
    echo $cnt

    # 若有必要的話，則刪除鎖定資料夾
    if [ "$1" = "lock" ]; then
	rmdir $LOCKDIR
    fi
}

# 在啟動時若已有鎖定資料夾存在的話，則顯示錯誤，並結束
if [ -d $LOCKDIR ]; then
    echo "Lock directory $LOCKDIR exist."
    exit 1
fi


# 在背景中同時啟動10個count函數
# 來看看數秒的情況

# 使用鎖定資料夾來執行
echo "*** WITH LOCK FILE ***"
echo 0 >$COUNTFILE
for i in 1 2 3 4 5 6 7 8 9 10; do
    count lock &
done
wait

# 不使用鎖定資料夾來執行
echo "*** WITHOUT LOCK FILE ***"
echo 0 >$COUNTFILE
for i in 1 2 3 4 5 6 7 8 9 10; do
    count &
done
wait

rm $COUNTFILE
