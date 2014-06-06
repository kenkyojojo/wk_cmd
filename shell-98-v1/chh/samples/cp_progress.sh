#! /bin/bash

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
} | dialog --guage "«þ¨©¶i«×" 10 50 0

