#!/bin/sh

# echo_n - 不換行的echo指令
echo_n() {
    echo $ECHO_N "$*"$ECHO_C
}

# 檢查echo指令的相容性
if [ -z `echo -n` ]; then
    # Solaris以外的情況
    ECHO_N="-n"
    ECHO_C=""
else
    # Solaris的情況
    ECHO_N=""
    ECHO_C="\c"
fi

# 畫面的寬度與高度
cols=`tput cols`
lines=`tput lines`

# 清除畫面
echo_n `tput clear`

# 用各種屬性來寫字
c=`expr $cols / 2 - 11`
echo_n `tput cup 2 $c`
echo_n "`tput rev`SAMPLE SCRIPT FOR TPUT`tput sgr0`"
echo_n `tput cup 5 $c`
echo_n "Number of lines:   `tput bold`$lines`tput sgr0`"
echo_n `tput cup 7 $c`
echo_n "Number of columns: `tput bold`$cols`tput sgr0`"
echo_n `tput cup 9 $c`
echo_n "`tput bold`BOLD`tput sgr0` "
echo_n "`tput rev`REVERSE`tput sgr0` "
echo_n "`tput smul`UNDERLINE`tput sgr0`"

# 將游標位置移動到畫面的最下方
r=`expr $lines - 1`
echo_n `tput cup $r 0`
