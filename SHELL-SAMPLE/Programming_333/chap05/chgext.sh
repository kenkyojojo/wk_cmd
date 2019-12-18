#!/bin/sh

# chgext.sh - 一舉變更檔案的副檔名

# 若引數未滿2個的話，則顯示使用說明
if [ $# -lt 2 ]; then
    echo "usage: chgext.sh .newext files..."
    exit 1
fi

newext="$1"  # 第1個引數表示新的副檔名
shift

# 若新的副檔名不是以「.」起頭的話，則加上去
# (這樣就可以寫成「.txt」或「txt」了。)
expr "$newext" : '\.' >/dev/null || newext=".${newext}"

# 對剩下所有的引數做同樣的處理
for fname do
    bname=`echo "$fname" | sed 's/\.[^.]*$//'`
    mv "$fname" "${bname}${newext}"
done
