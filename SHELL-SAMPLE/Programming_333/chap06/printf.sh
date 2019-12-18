#!/bin/sh

# printf.sh - printf的範例

printf '1: <%5d> <%05d> <%-5d> \n' 123 123 123
printf '2: <%5.2f> <%05.2f> <%.3e>\n' 1.234 1.234 1.234
printf '3: <%s> <%-10s> <%.5s>\n' 'HELLO' 'HELLO' 'HELLO-WORLD'
printf '4: miles\taway\n'
printf '5: BEEP!\a\n'

# 顯示目前進度很常使用的手法
i=0
while [ $i -le 10 ]; do
    printf '\rProcessing %2d/10...' $i
    i=`expr $i + 1`
    sleep 1
done
printf 'done\n'
