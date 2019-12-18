#!/bin/sh

# cond1.sh - 「&&」的例子

# [A] 只有在make成功的時候，執行make install
make && make install

# [B] 也可以連續寫3個以上的指令
configure && make && make install

# [C] 也可以在&&後面換行
configure &&
make &&
make install &&
make clean
