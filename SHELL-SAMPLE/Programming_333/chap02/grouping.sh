#!/bin/sh

# grouping.sh - grouping的例子

# 使make與make install在背景執行
# 只有在make成功的時候，才去執行make install
{ make && make install; } &

# 將檔案first、檔案second的內容連續寫到third中
{ cat first; cat second; } > third
