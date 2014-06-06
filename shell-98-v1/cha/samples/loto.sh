#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

# m 用來暫存取得的 6 個號碼
m=

#
# 函式區
#

# 取得一個 1 ~ 42 的號碼
function GetLOTO () {
   local r

   r=$(( $RANDOM % 43 ))

   # 若該號為 0, 則予以加 1
   if [ $r -eq 0 ]; then
   	  r=$[ r + 1 ]
   fi

   # 使每一個號碼都用二位數來表示，不足 10 者，在其前面補 0
   if [ $r -le 9 ]; then
      echo "0$r"
   else
      echo $r
   fi
}


function GenNumAndCheckRepeat () {
   local n

   # 取得 6 個號碼，並且予以排序
   m=$({ GetLOTO;  GetLOTO;  GetLOTO;  GetLOTO;  GetLOTO;  GetLOTO; } | sort -n)
      
   # 把這 6 個號碼暫時 copy 一份給 n
   n="$m"

   # 檢查這 6 個號碼有無重覆
   n=$(echo $n | tr ' ' '\n' | uniq -d)

   # 若 $n 為空, 表示沒有重覆, 則傳回真 ( 0 )
   if [ -z "$n" ]; then
      return 0
   else
      # 若 $n 非空, 表示有重覆, 則傳回假 ( 1 )
      return 1
   fi
}

#
# 主程式區
#

# 判斷使用者是否提供組數
if [ $# -ne 1 ]; then
   echo "使用法: $0 組數"
   exit
fi

# 組數要介於 1 ~ 99 組
if [ "$1" -lt 1 -o "$1" -gt 99 ]; then
   echo "使用法: $0 [1-99]組"
   exit
fi


# i 為累計的組數
declare -i i=1 j

# 當 i 小於或等於組數時，便用 while 迴圈產生下一組樂彩號碼
while [ $i -le "$1" ]
do
    # 取得 6 個號碼
    GenNumAndCheckRepeat

    # 若有重覆，則丟棄這 6 個號碼
    if [ $? -ne 0 ]; then
       continue
    fi

    # 調整輸出格式
    j=$i
    if [ $j -le 9 ]; then
       echo -n "第 0$j 組: "
    else
       echo -n "第 $j 組: "
    fi

    # 執行到此，表示該組號碼沒有重覆，予以顯示出來
    echo $m
 
    # 組數 加 1 
    i=$[ i + 1 ]
done

