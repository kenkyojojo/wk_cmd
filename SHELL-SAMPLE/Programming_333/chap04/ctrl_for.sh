#!/bin/sh

# ctrl_for.sh - for的例子

for item in one "two !" 'three !' four\ !; do
    echo "$item"
done
