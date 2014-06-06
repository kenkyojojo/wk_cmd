#! /bin/bash

PS3='請選擇: '
select f in *
do
   echo "您鍵入的編號是 $REPLY, 選擇的檔案是: $f"
done
