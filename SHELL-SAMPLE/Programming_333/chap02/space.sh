#!/bin/sh

# space.sh - 包含空白字元或特殊符號的引數之使用例

# 含空白字元的例子
echo "MILES        AWAY"         # [A] 用"..."括起
echo MILES\ \ \ \ \ \ \ \ AWAY   # [B] 在空白的前面加上「\」
echo MILES        AWAY           # [C] 直接寫入
                                 # (第2個之後的空白會被忽略)

# ޤ
echo "<TAG>"                     # [D] 用"..."括起
echo '<TAG>'                     # [E] 用"..."括起
echo \<TAG\>                     # [F] 在符號前面加上「\」
echo <TAG>                       # [G] 直接寫入(會發生錯誤)
