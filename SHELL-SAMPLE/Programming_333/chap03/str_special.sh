#!/bin/sh

# str_special.sh - 含控制文字的字串

# 找出能夠顯示16進位的傾印清單(dump list)的指令
# (在Solaris裡面是od，在其它則是使用hexdump)
hexdump=`which hexdump 2>/dev/null`
if [ -x "$hexdump" ]; then
    DUMP="hexdump -C"
else
    DUMP="od -tx1"
fi


## 直接代入
str=':
	'            # 雖然眼睛看不到，這裡輸入的是「':<ENTER><TAB>'」。
echo "$str" | $DUMP  # 顯示字串的16進位傾印


## 使用printf來代入
str=`printf ':\n\t'`
        # 「`...`」(指令替換)中因為最後的換行文字會被拿掉，所以
        # 「str=`printf ':\t\n'`」是無法成功的。
echo "$str" | $DUMP  # 顯示字串的16進位傾印

## 使用bash的「$'...'」來代入
str=$':\n\t'         # 這種表現方式只有在bash中才可以使用
echo "$str" | $DUMP  # 顯示字串的16進位傾印
