#!/bin/sh

# newuser_solaris.sh - 在Solaris中登錄新使用者

# 設定預設的所屬群組
PRIMARY_GROUP=staff

# 輸入使用者名稱(登入名稱)和本名
echo "login name: \c"
read login
echo "real name: \c"
read real

# 輸入初始密碼
stty -echo   # 不將輸入顯示在畫面上
echo "passowrd: \c"
read pass
echo
echo "password (retype to confirm): \c"
read pass2
echo
stty echo    # 變回原樣
if [ "$pass" != "$pass2" ]; then
    echo "Passwords do not match."
    exit 1
fi

# 確認是否可以登錄新的使用者
echo "Do you want to create new account? (y/n) \c"
read yesno

[ "$yesno" != "y" -a "$yesno" != "Y" ] && exit 1

# OK的話，則登錄使用者
/usr/sbin/useradd -c "$real" -g $PRIMARY_GROUP -m $login

# 設定密碼
expect -c "spawn passwd $login
expect \"Password:\"
send \"$pass\\r\"
expect \"Password:\"
send \"$pass\\r\"
expect eof" >/dev/null

echo "To rmove this account, type \"/usr/sbin/userdel -r $login\""
