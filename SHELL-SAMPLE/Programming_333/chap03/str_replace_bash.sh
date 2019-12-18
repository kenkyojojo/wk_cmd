#!/bin/bash

# str_replace_bash.sh - 取代字串（bash）

# 取代用的字串
text="The quick brown fox jumps over the lazy fox."

# 將text中的「fox」取代為「DOG」
echo ${text/"fox"/"DOG"}   # 只取代第一個fox
echo ${text//"fox"/"DOG"}  # 取代所有的fox

# 使用萬用字元的例子:把「jumps」之後的內容改為「jumps...」
echo ${text/"jumps*"/"jumps..."}
