#!/bin/sh

# envvar.sh - 環境變數的例子

# 將值設定到環境變數中
export USERNAME REALNAME
USERNAME=ichiro
REALNAME="SUZUKI Ichiro"

# 基本的使用方法和shell變數是一樣的
echo "Hello, $REALNAME"
echo "${USERNAME}san's mailbox is empty."

# 環境變數會被繼承到子行程
sh -c 'echo "REALNAME in child process: $REALNAME"'

# 但是，不會被反映在父行程上
sh -c 'REALNAME="NAKAHASHI Ichiro"'
echo "REALNAME has been changed in child process: $REALNAME"
