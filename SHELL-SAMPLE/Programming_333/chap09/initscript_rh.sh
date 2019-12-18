#!/bin/sh
# chkconfig: 2345 95 05
# description: Just for test

# initscript_rh.sh - RedHat系Linux的啟動script

case $1 in
  start)
    # 製作一個在啟動時做為記號的檔案，等候10秒
    touch /var/lock/subsys/initscript_rh.sh
    sleep 10
    exit 0
    ;;
  stop)
    # 在結束時將做為記號的檔案刪除，等候10秒
    rm /var/lock/subsys/initscript_rh.sh
    sleep 10
    exit 0
    ;;
esac

echo "usage: initscript_rh.sh {start|stop}"
exit 1
