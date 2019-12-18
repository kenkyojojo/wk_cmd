#!/bin/sh

# initscript_deb.sh - Debian GNU/Linux的啟動script

case $1 in
  start)
    # 啟動時顯示訊息並等候10秒
    echo -n "Running initscript_deb.sh for startup..."
    sleep 10
    echo "done."
    exit 0
    ;;
  stop)
    # 結束時顯示訊息並等候10秒
    echo -n "Running initscript_deb.sh for shutdown..."
    sleep 10
    echo "done."
    exit 0
    ;;
esac

echo "usage: initscript_deb.sh {start|stop}"
exit 1
