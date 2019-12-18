#!/bin/sh

# autoresponder.sh - 自動回覆郵件

FROM_ADDRESS="query@nnip.org"
TAB=`printf "\t"`

# cleanup
#     在shell script中斷．結束時會被呼叫的函數
cleanup() {
    [ -n "$temp" ] && rm $temp
}


# header
#     抽取出指定的標頭的內容
header() {
    sed '/^$/q' $temp | grep -i "$1:" | sed 's/.*:[ $TAB]*\(.*\)/\1/'
    # 用sed將訊息的開頭到第一個空行的部分抽取出來(/^$/)
    # 然後用grep將指定的標頭的那一行抽取出來
    # 然後再用sed將標頭的內容取出
    # 「:」的後面可能存在0個以上的空白字元或是縮排字元。
}


# 將接收的訊息存到暫存檔中
trap cleanup EXIT
trap exit INT
temp=`mktemp /tmp/autoresponder.XXXXXXXX` || exit 1
chmod 600 $temp
cat >> $temp

# 製作新郵件
mail_send.sh --send <<EOF
From: $FROM_ADDRESS
To: `header from`
Subject: 感謝您的來信
In-Reply-To: `header message-id`

非常感謝您的來信
關於您這次詢問的內容，本公司負責人員會在2個工作天內
以郵件給您答覆

...
EOF
