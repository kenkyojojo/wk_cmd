#!/bin/sh

# shellvar.sh - shell變數的例子

# 在shell變數中設定值
username=ichiro
realname="SUZUKI Ichiro"

# 只要使用「$變數名稱」就可以的例子
echo "Hello, $realname"

# 此例中，若省略「{}」的話，會變成「$usernamesan」，就錯了
echo "${username}san's mailbox is empty."

# shell變數並不會被繼承到子行程
sh -c 'echo "realname in child process: $realname"'
