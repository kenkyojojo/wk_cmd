#!/bin/sh

# newuser_osx.sh - 在Mac OS X中新增使用者

# 設定預設的所屬群組(用群組ID的數字)
PRIMARY_GROUP=20  #staff

# 輸入使用者名稱(登入名稱)和本名
echo -n "login name: "
read login
echo -n "real name: "
read real

# 輸入初始密碼
stty -echo   # 不會將輸入顯示在畫面上
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

# 確認是否可以登錄一個新的使用者
echo -n "Do you want to create new account? (y/n) "
read yesno

[ "$yesno" != "y" -a "$yesno" != "Y" ] && exit 1

# 從現在所登錄的所有使用者中，找出UID最大者
uid=`nidump passwd . | cut -f3 -d: | sort -rn | head -1`
# 在最大者加1，做為新的UID
uid=`expr $uid + 1`

# 製作新的使用者
if ! niutil -create / /users/$login; then
    echo "User $login already exist (or any unexpected error occured)."
    exit 1
fi
niutil -createprop / /users/$login realname "$real"
niutil -createprop / /users/$login uid $uid
niutil -createprop / /users/$login gid $PRIMARY_GROUP
niutil -createprop / /users/$login home /Users/$login
niutil -createprop / /users/$login _shadow_passwd

# 設定密碼
expect -c "spawn passwd $login
expect \"assword:\"
send \"$pass\\r\"
expect \"assword:\"
֡send \"$pass\\r\"
expect eof" >/dev/null

echo "You should manually create /Users/$login"
echo "To rmove this account, type \"niutil -destroy / /users/$login\""
