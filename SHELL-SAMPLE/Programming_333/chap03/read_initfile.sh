#!/bin/sh

# read_initfile.sh - 讀入初始設定檔

# 讀入initfile
. ./initfile  #「.」是「source」的簡寫

echo "*** System Analysis Report for ${hostname} ***"

# show_uptime=YES的話，則顯示系統的啟動時間
if [ "$show_uptime" = "YES" ]; then
    uptime
fi

# show_numprocs=YES的話，則顯示執行中的行程
if [ "$show_numprocs" = "YES" ]; then
    numprocs=`ps ax | wc -l`
    #numprocs=`ps -A | wc -l`  # Solaris的情況
    numprocs=`expr $numprocs - 1`
    echo "${numprocs} process(es) are running."
fi
