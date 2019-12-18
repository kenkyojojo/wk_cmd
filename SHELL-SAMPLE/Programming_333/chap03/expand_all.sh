#!/bin/sh

# expand_all.sh - 表示所有引數的方法

argcount() {
    echo "Number of arguments: $#"
    echo '$1:' "$1"
}

# "$*" 和 "$1 $2 $3 ..." 是同義的
# (所有的引數被看成一個字串)
echo 'argcount "$*"'
argcount "$*"

# "$@" 和 "$1" "$2" "$3" ... 是同義的
# (所有的引數會被看成各別的字串)
echo 'argcount "$@"'
argcount "$@"
