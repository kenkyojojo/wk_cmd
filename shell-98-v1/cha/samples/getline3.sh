#! /bin/bash

getline()
{
  local i=0
  while read line
  do
	  let ++i
      if (( $i > 10 )); then
         return 3
      fi
  done < $file
  echo "$file 共有 $i 列"
}

file=$1

getline

if [ $? -eq 3 ]; then
   echo '列數過多，放棄讀取.'
else
   echo 'getline 執行完畢'
fi
