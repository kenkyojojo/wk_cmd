#!/bin/sh

# noecho.sh - 禁止輸入的echoback

echo -n "Password: "
#echo "Password: \c"  # for Solaris

stty -echo
read password
stty echo

echo

if [ "$password" = "secret" ]; then
    echo "Open sesami!"
else
    echo "Bye!"
fi
