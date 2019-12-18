#!/bin/sh

# var_default.sh - 變數的預設值

# 若變數中有設定值的話，會使用它原本的值
fruit="an orange"
echo "Do you have ${fruit:-some fruit}?"

# 若變數為空值的話，則會使用指定的預設值
fruit=
echo "Do you have ${fruit:-some fruit}?"

# 若是使用「${var:=default}」的話，在var是空值的時候代入default
echo "My name is ${name:=Guest}."  # 由於name是未定義，所以會代入"Guest"
echo "Hello, ${name}!"
