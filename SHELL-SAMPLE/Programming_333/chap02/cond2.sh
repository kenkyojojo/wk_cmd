#!/bin/sh

# cond2.sh - 「||」的例子

# 若LOCKFILE的刪除動作失敗，則顯示訊息
rm LOCKFILE || echo "Can't remove LOCKFILE"
