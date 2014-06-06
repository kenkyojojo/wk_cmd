#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

#
# 宣告區
#
# 寄件者
From='admin@jack.edu.tw'

# 收件者
To='admin@sample.edu.tw'

# 主旨
Subject='測試通知'

# 信件內容
MsgTMP=$(mktemp)

sendmail='/usr/sbin/sendmail -t'

#
# 函式區
#

cr_msg() {
   cat <<EOF > $MsgTMP
From: $From
To: $To
Reply-To: $From
Subject: $Subject

這是一封測試信件. 請勿回信喔!

感謝您!

EOF

}

mailto() {
   # 建立信件內容
   cr_msg
   # 郵寄
   [ -f $MsgTMP ] && cat $MsgTMP | $sendmail
}

# 清除暫存檔
rmTMP() {
   [ -f $MsgTMP ] && rm -f $MsgTMP
}

#
# 主程式區
#

# 寄信
mailto

# 清理
rmTMP

# Done.
