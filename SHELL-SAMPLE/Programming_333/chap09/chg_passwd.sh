#!/bin/sh

# chg_passwd.sh - 變更密碼

# on_intr
#     中斷時執行的函數
on_intr() {
    stty echo
    exit 1
}

# 調查echo指令的相容性
if [ -z "`echo '\c'`" ]; then
    ECHO_N=""; ECHO_C="\c"
else
    ECHO_N="-n"; ECHO_C=""
fi

# 輸入新舊密碼
trap on_intr INT
stty -echo
echo $ECHO_N "Enter current password: $ECHO_C"
read now_pass
echo
echo $ECHO_N "Enter new password: $ECHO_C"
read new_pass
echo
echo $ECHO_N "Retype new password: $ECHO_C"
read new_pass2
echo
stty echo
trap INT
if [ "$new_pass" != "$new_pass2" ]; then
    echo "new passwords do not match."
    exit 1
fi

# 設定新的密碼
expect -c "set timeout 5
spawn passwd
expect \"assword:\"
send \"$now_pass\\r\"
expect {
    -re \"failure|\\[Ss\\]orry\"  { exit 1 }
    \"assword:\"
}
send \"$new_pass\\r\"
expect \"assword:\"
send \"$new_pass\\r\"
expect {
    -re \"unchanged|try again\"  { exit 1 }
    eof
}
exit [lindex [wait] 3]" >/dev/null

# 調查終止碼，顯示結果
if [ $? -eq 0 ]; then
    echo "Password has been changed succesfully."
    exit 0
else
    echo "Error. Password is left unchanged."
    exit 1
fi
