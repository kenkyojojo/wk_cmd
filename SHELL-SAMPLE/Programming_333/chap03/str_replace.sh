#!/bin/sh

# str_replace.sh - 使用sed來取代字串

# 取代用的字串
text="The quick brown fox jumps over the lazy fox."

# 將text中的「fox」取代為「DOG」
echo "$text" | sed 's/fox/DOG/'   # 只取代第一個出現的fox
echo "$text" | sed 's/fox/DOG/g'  # 將全部的fox取代掉

# 使用正規表示的例子:將「o」開頭的單字全部取代成「after」
echo "$text" | sed 's/\<o[^ ]*/after/'
