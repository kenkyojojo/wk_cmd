#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

FreeCmd="/usr/bin/free"

Mem=$($FreeCmd | grep ^Swap:)

TotalMem=$(echo $Mem | awk '{print $2}')
UsedMem=$(echo $Mem | awk '{print $3}')
FreeMem=$(echo $Mem | awk '{print $4}')

echo $TotalMem $UsedMem $FreeMem

