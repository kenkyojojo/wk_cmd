# dot_profile.sh - 在登入時執行script

# 將這個檔案複製到 ~/.profile 來使用

# 登入時顯示訊息
echo "Welcome to `hostname`"

# 設定PATH
PATH=$PATH:/usr/local/extra/bin
