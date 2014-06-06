#! /bin/bash

getline()
{
  local i=0
  while read line
  do
	  let ++i
  done < $file
  echo "$file 共有 $i 列"
}

file=$1

getline 

echo 'getline 執行完畢'
