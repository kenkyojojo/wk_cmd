#!/bin/sh

# ansi_color.sh - 改變文字顏色

# 代入ESC字元
ESC=`printf "\033"`

# echo_n - 不換行的echo指令
echo_n() {
    echo $ECHO_N "$*"$ECHO_C
}

# 設定echo指令的相容性
if [ -z `echo -n` ]; then
    # Solaris以外
    ECHO_N="-n"
    ECHO_C=""
else
    # Solaris的情況
    ECHO_N=""
    ECHO_C="\c"
fi

# 使文字顏色和屬性產生變化
for color in 30 31 32 33 34 35 36 37; do
    for attr in 0 1 4 5 7; do
	echo_n "${ESC}[${attr};${color}mCOLOR${ESC}[0m "
    done
    echo
done

# 使文字顏色和背景色產生變化
for fgcolor in 30 31 32 33 34 35 36 37; do
    for bgcolor in 40 41 42 43 44 45 46 47; do
	echo_n "${ESC}[${fgcolor};${bgcolor}mCOLOR${ESC}[0m "
    done
    echo
done
