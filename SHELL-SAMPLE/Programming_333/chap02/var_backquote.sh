#!/bin/sh

# var_backquote.sh - 指令替換的例子

# username中會代入現在登入的使用者的名稱
username=`id -un`
echo "$username"

# greeting中代入開頭問候語
greeting="Hello, `id -un`"
echo "$greeting"

# 不一定要代入到變數中，也可以直接用引數的方式來使用
echo "My name is `id -un`."
