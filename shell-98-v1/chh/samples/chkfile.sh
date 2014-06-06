#! /bin/bash

# 叫用函式庫 chkfile_fun.sh
. chkfile_fun.sh

if  test_filequal 1.txt 3.txt; then
	echo "檔案內容相同."
else
	echo "檔案內容不同."
fi
