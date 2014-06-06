#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

#
# 宣告區
#

# 建立日期
Date=$(date +'%Y%m%d%H%M%S')

# 要加入檢核的目錄，絕對路徑、以空白隔開
Dirs="/bin /sbin /usr/bin /usr/sbin /lib /usr/local/sbin /usr/local/bin /usr/local/lib /usr/X11R6/bin /usr/X11R6/lib"

# 暫存檔
tmpFile=$(mktemp)

# 檔案 checksum 值儲存檔
FP="/root/fp.$Date.chksum"

# 使用哪一種 checksum 工具
Checker="/usr/bin/md5sum"
# Checker="/usr/bin/sha1sum"

Find="/usr/bin/find"

#
# 函式區
#

# 掃瞄要檢核的目錄，建立檔案列表
scan_files() {
   local f
   for f in $Dirs
   do
      $Find $f -type f >> $tmpFile
   done
}

# 讀取檔案列表，建立各個檔案的 checksum 值列表
cr_checksum_list() {
   local f
   if [ -f $tmpFile ]; then
      for f in $(cat $tmpFile);
          do $Checker $f >> $FP
      done
   fi
}

# 清除暫存檔
rmTMP() {
   [ -f $tmpFile ] && rm -f $tmpFile
}

#
# 主程式區
#

# 掃瞄檔案列表
scan_files

# 建立檔案的 checksum 值
cr_checksum_list

# 清理暫存檔
rmTMP
