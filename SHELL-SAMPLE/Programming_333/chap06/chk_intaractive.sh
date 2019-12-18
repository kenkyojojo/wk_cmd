#!/bin/sh

# chk_interactive.sh - 調查是否為對話模式

# 若是對話模式的話，對使用者發出問題
if test -t 0; then
    echo "Are you sure?  Press Ctrl-C to abort, or Enter to continue."
    read dummy
fi

# 實際的處理
echo "DO SOMETHING!"
