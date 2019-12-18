#!/bin/sh

# subshell.sh - subshell的例子

# [A] 在背景中執行make與make install
#     (只有在make成功的時候，才去執行make install)
( make && make install ) &

# [B] 將~/source底下的檔案壓縮之後，
#     寫入到~/target/archive.tar.gz中。
#     tar會在目前資料夾是~/source的狀態下被執行。
#     gzip會在目前資料夾是~/target的狀態下被執行。
cd $HOME/target
(cd $HOME/source; tar cf - *) | gzip -c > archive.tar.gz
