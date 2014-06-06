#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

T="/usr/bin/top"

show_loading=$($T | head -1)

L1=$(echo $show_loading | awk '{print $11}') 
L5=$(echo $show_loading | awk '{print $12}')
L15=$(echo $show_loading | awk '{print $13}')

L1=${L1%,*}
L5=${L5%,*}
L15=${L15%,*}

echo "1、5、15分鐘的平均負載為: $L1 $L5 $L15" 
