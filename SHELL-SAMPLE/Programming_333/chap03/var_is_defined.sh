#!/bin/sh

# var_is_defined.sh - 調查變數是否有被定義

is_defined() {
    varname="$1"
    if set | grep -q "^${varname}="; then
	echo "${varname} is defined."
    else
	echo "${varname} is NOT defined."
    fi
}

# foo是空的，但有被定義
foo=""

is_defined "PATH"
is_defined "foo"
is_defined "bar"

# 取消foo的定義，重新調查一次
unset foo
is_defined "foo"
