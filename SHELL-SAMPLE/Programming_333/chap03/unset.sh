#!/bin/sh

# unset.sh - 取消變數的定義

# 將值設定到foo裡面
foo="bar"
echo "Before unset: $foo"

# 取消foo
unset foo
echo " After unset: $foo"

# 環境變數也可以取消
unset PATH
ls
