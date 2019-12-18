#!/bin/sh

# echo.sh - echo的範例

# 含空白字元的情況
echo 1: Hoge   Hoge
echo "2: Hoge   Hoge"

# 含特別符號的情況
echo 3: *.sh $PWD
echo "4: *.sh $PWD"
echo '5: *.sh $PWD'
