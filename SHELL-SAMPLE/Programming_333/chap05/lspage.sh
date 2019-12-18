#!/bin/sh

# lspage.sh - 將ls指令的結果逐頁顯示

ls "$@" | ${PAGER:-more}
