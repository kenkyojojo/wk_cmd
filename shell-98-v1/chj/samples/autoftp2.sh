#! /bin/bash

Filename="mmm.tgz"
HOST="192.168.1.1"

cd /root

ftp $HOST <<EOF 
put $Filename
quit
EOF
