#!/bin/sh

# lang.sh - 變更語言環境的例子

# 改變LANG的值來執行date
for LANG in C ja_JP.eucJP ja_JP.UTF-8 en_US.ISO8859-1 fr_FR.ISO8859-1; do
    echo -n "$LANG -- "
    #echo "$LANG -- \c"   # Solaris的情況
    date
done
