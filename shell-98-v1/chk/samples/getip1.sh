#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

ListIPcmd="/sbin/ifconfig"

IP=$($ListIPcmd | grep 'inet addr:' | grep -v '127.0.0.1' | awk '{print $2}' | awk -F: '{print $2}')

echo $IP
