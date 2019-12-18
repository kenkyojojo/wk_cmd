#!/bin/sh

# pipe.sh - pipe的使用法

# 將系統記錄檔(system log)的內容逐頁輸出
demsg | less

# 將系統記錄檔中，含有「irq」(不論大小寫)的那一行
# 逐頁輸出
dmesg | grep -i 'irq' | less
