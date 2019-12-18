#!/bin/sh

# newuser_linux.sh - 在系統新登錄一個使用者(Linux)

# 設定預設的所屬群組
PRIMARY_GROUP=staff

# 輸入使用者名稱(登入名稱)和本名
echo -n "login name: "
read login
echo -n "real name: "
read real

# 輸入初始密碼
stty -echo   # 不將輸入顯示在畫面上
echo -n "passowrd: "
read pass
echo
echo -n "password (retype to confirm): "
read pass2
echo
stty echo    # 變回原樣
if [ "$pass" != "$pass2" ]; then
    echo "Passwords do not match."
    exit 1
fi

# 對使用者確認是否要新登錄一個使用者
echo -n "Do you want to create new account? (y/n) "
read yesno

[ "$yesno" != "y" -a "$yesno" != "Y" ] && exit 1

# 若OK的話，則登錄新使用者
useradd -c "$real" -g $PRIMARY_GROUP -m $login

# 設定密碼
expect -c "spawn passwd $login
expect \"password:\"
send \"$pass\\r\"
expect \"password:\"
send \"$pass\\r\"
wait" >/dev/null

echo "To rmove this account, type \"userdel -r $login\""
