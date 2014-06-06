#! /bin/bash

# 使用 Xdialog 的版本

shopt -s -o nounset

declare -i p=0
SRC="src.iso"
DEST="dest.iso"

Total=$(stat -c %s $SRC)
touch $DEST

(cp -f $SRC $DEST; sync) &

{
while ((p < 100))
do
    Size=$(stat -c %s $DEST)
    p=Size*100/Total
    echo $p
    sleep 1
done
} | Xdialog --guage "拷貝進度" 10 50 0

