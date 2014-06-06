#! /bin/bash

{ 
  for ((i=1;i<=10;i++))
  do
      let I=10*i
      echo $I
      sleep 1
  done
} | dialog --guage "安裝進度" 5 60 0
