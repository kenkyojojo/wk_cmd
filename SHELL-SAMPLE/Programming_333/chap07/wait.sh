#!/bin/sh

# wait.sh - 等待子行程結束

# 將這個函數當成子行程(subshell)來執行
sub_process() {
    echo "Sub-process: start"
    sleep 5
    echo "Sub-process: end"
}

sub_process &  # 在背景執行子行程
wait $!        # 等候子行程結束
echo "Finished!"
