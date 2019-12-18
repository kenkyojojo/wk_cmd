#!/bin/sh

# source_sub.sh - source指令的例子(被讀取函數的一方)

# uname指令會列出OS的版本或CPU的種類等資訊

get_systype() {
    MACHINE=`uname -m`
    PROCESSOR=`uname -p`
    OS=`uname -s`
}
