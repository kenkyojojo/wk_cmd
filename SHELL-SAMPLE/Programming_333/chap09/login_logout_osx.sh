#!/bin/sh

# login_logout_osx.sh - 在Mac OS X中，在登入．登出時執行script

# at_logout
#     寫上登出時欲執行的指令
at_logout() {
    # 利用AppleScript來發出"Good Bye"
    osascript -e 'say "Good bye"'
}

# 寫上登入時要執行的指令
# 使用AppleScript，來發出"Welcome to <HOSTNAME>"
osascript -e "say \"Welcome to `hostname -s`\""

# 等候登出
trap at_logout EXIT
while true; do
    sleep 60
done
