#! /bin/bash

MYLIB_DIR="~/libs"
if [ ! -d "$MYLIB_DIR" ]; then
   MYLIB_DIR='.'
fi

. $MYLIB_DIR/mylib1.sh

_getip eth0

ip=${FUNREPLY[0]}
if [ -n "$ip" ]; then
   echo "主機 IP 是: $ip"
else
   echo "找不到 IP"
fi
