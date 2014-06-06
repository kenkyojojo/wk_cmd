#! /bin/bash

getline()
{
  local i=0
  while read line
  do
	  let ++i
      if (( $i > 10 )); then
         echo "已超過 10 列了，不再繼續讀取."
         return 3
      fi
  done < $file
  echo "$file 共有 $i 列"
}

file=$1

getline

echo $?
echo 'getline 執行完畢'
