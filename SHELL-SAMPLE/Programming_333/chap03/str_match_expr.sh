#!/bin/sh

# str_match_expr.sh - 抽取出與正規表示一致的部分

# 處理對象字串（HTML的一部分）
text="<a target=WINDOW href=URL>ANCHOR</a>"

# 將標籤或錨點的必要部分抽取出來
expr "$text" : '.* \(target=[^ >]*\)'
expr "$text" : '.* href=\([^ >]*\)'
expr "$text" : '.*>\(.*\)<'
