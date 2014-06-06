#! /bin/bash

# 把 $2 的內容轉向附加到 $1 指定的檔案中
appendfile() {
   echo "$2" >> "$1"
}

Dir=~/tmp
OutFile="$Dir/tmp.txt"

# 若目錄不存在，則開新目錄
[ -e $Dir ] || mkdir -p $Dir 

appendfile $OutFile "函式也可以這樣用"
appendfile $OutFile "這是函式的另一種用法"
appendfile $OutFile "Over."
