#!/bin/bash

# stdinout_file_bash.sh - 「>(command)」的例子

# wget是從指定的URL下載檔案的指令
# (http://www.gnu.org/software/wget/wget.html)
# 「-o」選項是指定記錄檔的記錄目的地
# 使用「-O -」之後，下載下來的檔案會被顯示在標準輸出

# logger是將指定的訊息送到syslog的指令。
# (會記錄在/var/log/syslog等位置)

# nkf是轉換文字碼的指令

nkfopt=-w  # 終端的文字碼是EUC-JP的話使用「-e」
           # UTF-8的話使用「-w」

wget -o >(logger) -O - http://www.shuwasystem.co.jp | nkf -S $nkfopt
