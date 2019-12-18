#!/bin/sh

# np_client.sh - 使用FIFO的用戶端行程

PIPE=/tmp/np_server.pipe

# 確認伺服器是否為執行中
if [ ! -e $PIPE ]; then
    # 若FIFO不存在的話，則顯示錯誤並結束
    echo "np_server.sh is not running."
    exit 1
fi

# 與伺服器連線，並確認版本
echo "SVER" >>$PIPE
read code ver <$PIPE
echo "Connected to np_server.sh (ver $ver)"

# 將從標準輸入讀入的資料傳送給伺服器，取得單字數
wcnt=0
while read line; do
    echo WCNT "$line" >> $PIPE
    read code c < $PIPE
    wcnt=`expr $wcnt + $c`
done

# 顯示單字個數的總合
echo $wcnt
