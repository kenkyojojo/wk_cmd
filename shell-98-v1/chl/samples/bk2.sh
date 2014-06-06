#! /bin/bash

RSYNC="/usr/bin/rsync"
para="-avHS --numeric-ids"
pwdfile="--password-file=/root/rsyncd.secrets"
user="mch1_backup"
server="bk.sample.edu.tw"
block="mch1"

$RSYNC $para $pwdfile /var/www --exclude www/upload $user@$server::$block
$RSYNC $para $pwdfile /home $user@$server::$block
