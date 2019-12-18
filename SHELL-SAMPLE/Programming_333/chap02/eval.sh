#!/bin/sh

# eval.sh - eval指令的例子

L="l"
S="s"
dash="-"

eval "$L$S $dash$L"  # 會執行ls -l
