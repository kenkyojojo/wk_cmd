#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

HD=${1:?'請提供磁碟機的設備名稱，比如：hda 或 sda'}

SIZE=$(fdisk -l /dev/$HD | grep "heads,*" | awk '{print $1 * $3 * $5 / 2048}')

echo "磁碟機 $HD 的容量大小為 $SIZE MB."
