#!/bin/sh

# var_scope.sh - 變數的有效範圍

# func_A宣告了區域變數var，並變更其值，然後呼叫了func_B。
# func_B並沒有宣告區域變數var，所以依照C、perl、ruby的觀點來看，
# 這個值相當於全域變數（以此例來講就是「Global Value」）。
# 但是，在shell script中，會繼承呼叫者的值，
# 所以應該會是在func_A的值，也就是「function A」才對。

func_B() {
    echo $var
}

func_A() {
    local var
    var="function A"
    func_B
}

var="Global Value"
func_A
