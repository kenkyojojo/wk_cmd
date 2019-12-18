#!/bin/sh

# str_multiline.sh - 寫一個橫跨多行的字串

# 把「三隻小豬」裡面的小豬換成河馬，把母親換成父親
# (把一個包括換行字元的指令交給sed去處理)
cat <<'EOF' | sed 's/pigs/HIPPOPOTAMUSES/g
s/mother/FATHER/g'
Once upon a time there were three little pigs and the time came for 
them to leave home and seek their fortunes.
    Before they left, their mother told them "Whatever you do, do it 
the best that you can because that's the way to get along in the world.
EOF
