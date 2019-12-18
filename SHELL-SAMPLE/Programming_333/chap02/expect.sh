#!/bin/sh

# expect.sh - 用重新導向或expect來控制ftp的例子

# 使用ftp來取得ftp.kernel.org的檔案一覽表。
# 我們可以使用重新導向的方式，或是使用expect。

EMAIL='your@email.address.here'  # 寫入郵件位址

# [使用重新導向的方法]
#  依照原先預定的順序送出ftp的指令。
#  至於錯誤發生時該怎麼對應，則不列入考慮。
#  使用重新導向的方法中，無法順利對「Password:」做輸入
#  因此禁止ftp自動登入(「-n」選項)、
#  使用open和user指令來做登入
echo "open ftp.kernel.org
user anonymous $EMAIL
ls
bye" | ftp -n

echo
echo "----"
echo

# [使用expect的方法]
#  等待各提示字元被輸出，再送出使用者名稱、密碼等資料
#  (「\r」表換行)。
#  若等待20秒還沒有出現登入提示字元的話(=無法連線到ftp伺服器)
#  則中斷處理
expect -c "
set timeout 20
spawn ftp ftp.kernel.org
expect {
  timeout   exit
  \"Name\"
}
send \"anonymous\r\"
expect \"Password:\"
send \"$EMAIL\r\"
expect \"ftp>\"
send \"ls\r\"
expect \"ftp>\"
send \"bye\r\"
"
