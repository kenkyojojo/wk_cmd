#! /bin/bash

declare -i i=0
set 61 62 63 64 65 66 67 68 69 70 71 72

for p in $@
do
	((i++))
    echo "第 $i 個位置參數 \$$i = $p"
done
