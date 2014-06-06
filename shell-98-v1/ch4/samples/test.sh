#! /bin/bash
#
# 用途: 這是一個簡單的 shell 示範程式
#
#

function show_name() {
		 echo "今個兒是 $1，您 $2 大大，來自 $3"
}

name="$1"
ip="163.26.197.1"
today=`date +%F`

if [ $# != 1 ]; then
   echo "Usage: ./$0 [使用者名稱]"
   exit
fi

show_name "$today" "$name" "$ip" 

sleep 5

echo
echo "Bye-Bye ;-)"
