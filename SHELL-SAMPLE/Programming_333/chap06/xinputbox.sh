#!/bin/sh

# xinputbox.sh - 在GUI中取得1行的輸入

answer=`Xdialog --stdout --inputbox "May I have your name, please?" \
    8 70 "Anonymous Coward"`
Xdialog --msgbox "Your name is $answer" 8 70
