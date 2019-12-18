#!/bin/sh

# var_echo.sh - 讓變數的內容變成指令的輸入

greeting="Hello, brother!"
echo "$greeting" | sed 's/Hello/Good morning/'
