#!/bin/sh

# shutdownscriptd.sh - 使Mac OS X也可以在shutdown時執行處理

# at_shutdown
#     shutdown時被執行的處理
at_shutdown() {
    # 製作做為記號的檔案
    touch /shutdown-stamp
}

# 在shutdown的時候，若執行這個script，則會去執行at_shutdown
trap 'at_shutdown' EXIT

# 在shutdown之前，消磨時間
while true; do
    sleep 3600
done
