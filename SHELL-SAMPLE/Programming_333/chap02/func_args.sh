#!/bin/sh

# func_args.sh - 傳遞引數給函數

# 函數arg_report會把接收到的引數的總數，以及前面3個引數顯示出來
arg_report() {
    echo "Number of args: $#"
    echo "     First arg: $1"
    echo "    Second arg: $2"
    echo "     Third arg: $3"
}

# 配合各種引數來呼叫看看
arg_report foo
arg_report foo bar
arg_report foo bar "baz baz"
