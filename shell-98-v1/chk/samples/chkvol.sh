#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

#
# 宣告區
#
# 欲檢查的分割區，請以空白隔開。
partitions="/ /bk /backup"

# 寄件者
From='admin@jack.edu.tw'

# 收件者
To='admin@sample.edu.tw'

# 主旨
Subject='分割區空間使用量監測通知'

# 信件內容
Msgbody=

# 警示百分比，預設達到 90% 就發出警告通知
declare -i AlertPcent=90

# TOTAL: 磁碟空間已使用量, TOTALavl: 剩餘可用空間
declare -i TOTAL TOTALavl

mail='/usr/bin/mail'
HostCmd="/bin/hostname"

# 主機名稱
HostName=$($HostCmd)

#
# 函式區
#

# 已用量百分比
get_usedTotalPcent() {
    local tmp pcent
    declare -i pcent
    # 取得已用量之百分比，比如 59%
	tmp=$(df -B 1024K | grep ${p}$ | awk '{print $5}')
    # 去掉 % 的符號
    pcent=${tmp%\%*}
    return $pcent
}

# 已用量
get_usedTotal() {
	TOTAL=$(df -B 1024K | grep ${p}$ | awk '{print $3}')
}

# 剩餘可用量
get_avaibleTotal() {
	TOTALavl=$(df -B 1024K | grep ${p}$ | awk '{print $4}')
}

# 郵寄通知
mailto() {
   echo "$Msgbody" | mail -a "From: $From" -s "$Subject" $To
}

#
# 主程式區
#

p=
pcent=
if [ -n "$partitions" ]; then
   for p in $partitions
   do
      get_usedTotalPcent $p
      pcent=$?

      # 是否已達警示百分比
      if [ $pcent -ge $AlertPcent ]; then
         get_usedTotal $p
         get_avaibleTotal $p
         Msgbody=$Msgbody" 分割區 $p 目前使用量 $TOTAL MB，已達 $pcent%，剩餘可用空間 $TOTALavl MB，請儘速處理."
      fi
   done
   if [ -n "$Msgbody" ]; then
      Msgbody="$HostName 主機: "$Msgbody
      mailto
   fi
fi
