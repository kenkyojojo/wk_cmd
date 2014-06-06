#! /bin/bash

#
# 宣告區
#

# 會自動倒帶
tape=st0
# 不自動倒帶
ntape=nst0

#
# 函式區
#

# 倒帶
rewind_tape() {
   mt -f /dev/$ntape rewind
}

# 移到最後一個檔案末端
to_end() {
   mt -f /dev/$ntape eod
}

# 退出磁帶匣
offline() {
   mt -f /dev/$ntape offline
}

# 查看狀態
check_status() {
   mt -f /dev/$ntape staus
}

# 往後移動 n 個檔案，$1 欲移動的檔案數
forward_n() {
   mt -f /dev/$ntape fsf $1
}

# 往前移動 n-1 個檔案，$1 為欲移動的檔案數+1
# 例如要往前移動 1 個檔案，要執行 back_n 2
back_n() {
   mt -f /dev/$ntape bsfm $1
}

# 查出共有幾個備份檔
count_total() {
   local t
   # 移到磁帶最末端
   mt -f /dev/$ntape eod
   # 取得全部的檔案數
   t=$(mt -f /dev/nst0 status | grep '^File number' | awk -F, '{print $1}' | awk -F= '{print $2}')
   return $t
}
