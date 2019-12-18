#!/bin/sh

# exec_redirect.sh - 對多個指令有效的重新導向


# 使用grouping的例子
#   只顯示同時存在於資料夾dir1與dir2中的檔案

{ ls dir1; ls dir2; } | sort | uniq -d


# 使用exec的例子

echo "Terminal - line 1"   # 顯示到畫面上

# 使用「3>&1」之後，file handle3會被連到現在的標準輸出(=終端)
# (這麼做的目的是，等一下才能恢復原狀)。另外，用「>file」之後
# 標準輸出會被重新導向到檔案file。
exec 3>&1 >file

echo "File - line 1"       # 寫到檔案
echo "File - line 2"       # 寫到檔案

# 使用「>&3」之後，標準輸出會被連到file handle3(=終端)(也就是恢復原狀了)
# 使用「3>&-」之後，file handle3就被關閉了。
exec >&3 3>&-

echo "Terminal - line 2"   # 寫到畫面
