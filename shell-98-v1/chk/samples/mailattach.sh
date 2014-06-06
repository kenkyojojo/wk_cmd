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
tmpfile=$(mktemp)

sendmail='/usr/sbin/sendmail -t'

# zip 的 MIME 型態
Mime='application/x-zip-compressed'

# 要編碼的 zip 檔存放的路徑檔名
ZIPfile="/root/tmp/i.zip"

# zip 檔的檔名，不含路徑
FileName=${ZIPfile##/*/}

# 編碼後暫時放入此變數中
EncodeTMP=

#
# 函式區
# 

# 產生邊界所需的 32 個字元長度的隨機字串
gen_boundary() {
   local tmp
   tmp=$(head -1 /dev/urandom | od -N 2 | head -1 | awk '{print $2 * 1}' | md5sum)
   boundary="${tmp:0:32}"
}

encode_file() {
   local tmp tmp2
   cat $ZIPfile | uuencode -m $FileName > $tmpfile
   # 刪除第一列
   sed '1,1d' $tmpfile > $MsgTMP
   # 刪除最後一列
   sed '$d' $MsgTMP > $tmpfile
   EncodeTMP=$(cat $tmpfile)
}

cr_msg() {
   # 產生邊界
   gen_boundary
   # 產生信件
   cat <<EOF > $MsgTMP
From: $From
To: $To
Reply-To: $From
Subject: $Subject
Content-Type: multipart/mixed; boundary="$boundary"


--$boundary
Content-Type: text/plain;
        charset="big5"


這是測試信!

勿回信喔!

--$boundary
Content-Type: $Mime; name="$FileName"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="$FileName"


$EncodeTMP

--$boundary--


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
   [ -f $tmpfile ] && rm -f $tmpfile
}

#
# 主程式區
#

# 對二進位檔進行編碼
encode_file

# 寄信
mailto

# 清理
rmTMP

# Done.
