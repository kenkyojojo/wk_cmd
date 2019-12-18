#!/bin/sh

# var_readonly.sh - 把變數設為唯讀

foo="foo bar bar"
readonly foo
foo="baz baz foo"  # 會發生錯誤
