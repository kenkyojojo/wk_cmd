#! /bin/bash

myfun()
{
  local v
  echo "$FUNCNAME 中的變數 v = $v"
  v=888
  echo "$FUNCNAME 中的變數 v = $v"
}

v=999
myfun
echo "主程式中的變數 v = $v"
