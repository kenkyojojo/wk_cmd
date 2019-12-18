#!/bin/sh

# mail_send.sh - 整理郵件的格式，若有必要的話送出郵件

# 從標準輸入接收訊息，進行漢字碼的轉換．標頭的MIME編碼之後
# 寫到標準輸出上
# (若有指定選項「--send」的話，則送出郵件)
#
# 若沒有「From:」「Message-Id:」標頭的話，則把它加上去
# sendmail的「-f」選項永遠都是傳FROM_ADDRESS(在這個script中有定義)給它
# 

# 調查sendmail的位置
if [ -x /usr/sbin/sendmail ]; then
    SENDMAIL_PATH="/usr/sbin/sendmail"
elif [ -x /usr/lib/sendmail ]; then
    SENDMAIL_PATH="/usr/lib/sendmail"
else
    echo "sendmail not found."
    exit 1
fi

# 設定要設定到From:的郵件位址
FROM_ADDRESS="ichiro@nnip.org"
FROM_REALNAME="中橋 一朗"

LF='
'

# 若有支援的話則使用「read -r」
if echo x | read -r 2>/dev/null; then
    READ_R="-r"
else
    READ_R=""
fi


# tohex
#     將從標準輸入讀入的資料用16進位傾印(dump)的函數

tohex() {
    od -x | head -1 | sed -e 's/[^ ]* //' -e 's/ //g'
}


# msgid
#     產生Message-Id的函數

msgid() {
    # 雖然沒有一個固定的產生方法，但基本上必須讓所有的訊息都有不同的
    # Message-Id。這裡舉的是一個例子。

    # 日期時間
    datestr=`date +%Y%m%d.%H%M%S`
    # 從/dev/random讀入8個位元組，然後用16進位法表示
    random=`dd if=/dev/random bs=8 count=1 2>/dev/null | tohex`

    # 從寄件人的郵件位址取出網域名稱
    domain=`expr "$FROM_ADDRESS" : ".*@\(.*\)"`

    echo "$datestr-$$-$random@$domain"
}


# fixheader
#     這個函數會把欠函缺的標頭追加上去

fixheader() {
    # 從標準輸入讀入訊息，抽取出標頭的部分
    header=""
    while read $READ_R line; do
	[ -z "$line" ] && break
	header="$header$line$LF"
    done

    # 調查標頭
    ## 用grep -qvi
    if echo "$header" | grep -qi '^from:'; then
	:
    else
        # 若找不到「From:」的話，則追加上去
	header="${header}From: $FROM_REALNAME <$FROM_ADDRESS>$LF"
    fi
    if echo "$header" | grep -qi '^message-id:'; then 
        :
    else
	# 若找不到「Message-Id:」的話，則追加上去
	header="${header}Message-Id: <`msgid`>$LF"
    fi

    # 輸出標頭與本文
    echo "$header"
    cat
}

# 處理命令列選項
if [ "$1" = "--send" ]; then
    emit="$SENDMAIL_PATH -t -f $FROM_ADDRESS"
    shift
else
    emit="cat"
fi
if [ -n "$1" ]; then
    echo "usage: mail_send.sh [--send]"
    exit 1
fi

# 處理郵件
fixheader | nkf -j | enMime | $emit
