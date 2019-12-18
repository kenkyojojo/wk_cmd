#!/bin/sh

# nice.sh - nice指令的範例

# do_load
#     讓系統增加負荷(提高CPU使用率)的函數
do_load() {
    while true; do
	gzip -9 -c /bin/sh > /dev/null  # 增加系統負荷
    done
}

# 在背景中增加系統負荷
do_load &
bgpid=$!

# 用不同的nice值去執行程式
time nice -n 0  gzip -9 -c /bin/sh > /dev/null
time nice -n 10 gzip -9 -c /bin/sh > /dev/null
time nice -n 20 gzip -9 -c /bin/sh > /dev/null

# 結束背景行程
kill $bgpid
