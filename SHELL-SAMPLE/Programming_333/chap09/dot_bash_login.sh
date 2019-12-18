# dot_bash_login.sh - 在登入時執行script(bash用)

# 將這個檔案複製到 ~/.bash_login 來使用

# 在登入時顯示訊息
echo "Welcome to `hostname`"

# 設定PATH
PATH=$PATH:/usr/local/extra/bin

# 若 ~/.bashrc 存在的話，則讀入
[ -f ~/.bashrc ] && . ~/.bashrc
