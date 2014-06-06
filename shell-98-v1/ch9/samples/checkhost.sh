#! /bin/bash

[ -e "/etc/hosts" ] || (echo '/etc/hosts 檔案不存在.'; exit 1)
if [ "$?" -eq 1 ]; then
   exit
fi
echo '/etc/hosts 檔案存在，後續處理繼續執行下去....'
