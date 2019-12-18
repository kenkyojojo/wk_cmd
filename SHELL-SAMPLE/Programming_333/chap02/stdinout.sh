#!/bin/sh

# stdinout.sh - 標準輸入輸出的使用方法

# ls是把檔案的一覽表寫到標準輸出的指令
ls

# ls的標準輸出會被連到less的標準輸入。
# less在不指定檔名時，會從標準輸入讀取資料
# 逐頁寫入到標準輸出
ls | less  

# ls的標準輸出會被連到檔案list.out
# (ls的結果會被寫入到list.out)
ls > list.out

# less的標準輸入會被連到list.out
# (list.out的內容會被逐頁顯示)
less < list.out
