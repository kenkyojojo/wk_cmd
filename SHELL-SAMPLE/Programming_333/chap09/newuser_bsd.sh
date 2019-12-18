#!/bin/sh

# newuser_bsd.sh - 在FreeBSD中新增一個使用者

# 設定預設的所屬群組
PRIMARY_GROUP=staff

# 輸入使用者名稱(登入名稱)和本名
echo -n "login name: "
read login
echo -n "real name: "
read real

# 輸入初始密碼
stty -echo   # 不將輸入顯示到畫面上
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

# 確認是否可以新增一個使用者
echo -n "Do you want to create new account? (y/n) "
read yesno

[ "$yesno" != "y" -a "$yesno" != "Y" ] && exit 1

# OK的話就登錄新使用者
tmp=`mktemp /tmp/newuserXXXXXXXX`
echo "$login::::::$real:::$pass" >>$tmp
adduser -f $tmp
rm $tmp

echo "To rmove this account, type \"rmuser -y $login\""
