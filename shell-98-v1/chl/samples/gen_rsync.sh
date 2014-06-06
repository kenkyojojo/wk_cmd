#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

#
# 宣告區
#

# 備份伺服器的主機名稱。將做為產生器製作的設定檔的儲存目錄。
server_name=${1:?'請提供備份伺服主機的名稱，比如： bksvr'}

# client 端要備份出去的目錄，請用空白字元隔開
bk_dirs="/home /etc /var/lib/mysql"
# client 端主機名稱
mach="mch1"

# 備份伺服器的完整主機名稱或 IP
server_addr="bk.sample.edu.tw"
# 帳號
act="$mach"_backup
# 密碼
pwd="thisispwd"
# Server 端備份儲存區
BK_SAVE="/bk"

# rsync 的參數
para="-avHS --numeric-ids"

# client 端若有不存在的檔案，亦刪去備份主機上對應的檔案。
# 若您要使用這樣的功能，請改用這個參數
#para="-avHS --numeric-ids --delete"

#----------------------------------------------
# 備份伺服器的主要設定檔
server_conf="$server_name/svr/rsyncd.conf"
# 備份伺服器的授權帳號密碼檔
server_pwdfile="$server_name/svr/rsyncd.secrets"

# 給 client 端執行的備份 script
client_script="$server_name/clt/bk-$mach-to-$server_name.sh"
# client 端需用到的密碼檔
client_pwdfile="$server_name/clt/rsyncd.secrets"
# 備份 client 端的工作排程檔
client_cron="$server_name/clt/cron.tab"
# 安裝用的 script
installer="$server_name/install.sh"


#
# 函式區
#

# 以 client 端主機名稱為存檔的目錄
cr_client_dir() {
   if [ -f "$server_name" ]; then
      echo "$server_name 這個檔案已存在，請改名或移開它."
      exit 1
   fi
   
   if [ ! -d "$server_name" ]; then
      mkdir -p "$server_name/svr"
      mkdir -p "$server_name/clt"
   fi
}

# 建立 client 端需用到的密碼檔
cr_client_pwdfile() {
   cat <<EOF > $client_pwdfile
$pwd
EOF

   chmod 600 $client_pwdfile
}

# 建立 clinet 端用的備份 script
cr_run_script() {
   cat <<EOF > $client_script
#! /bin/bash

RSYNC="/usr/bin/rsync"

EOF

# 建立備份指令列
   for dir in $bk_dirs
   do
      cat <<EOF >> $client_script
\$RSYNC $para --password-file=/root/rsyncd.secrets $dir $act@$server_addr::$mach
EOF

done

   chmod +x $client_script
}

# 建立 client 端的工作排程
cr_crontab() {
   cat <<EOF > $client_cron
0 1 * * * /root/bk-$mach-to-$server_name.sh
EOF
}


# 建立備份伺服器的主要設定檔
cr_rsync_conf() {
   cat <<EOF > $server_conf
log file = /var/log/rsyncd.log

[$mach]
   path = $BK_SAVE/$act
   auth users = $act
   uid = root
   gid = root
   secrets file = /etc/rsyncd.secrets
   read only = no
EOF
}

# 建立備份伺服器的密碼檔
cr_rsync_pwdfile() {
   cat <<EOF > $server_pwdfile
$act:$pwd
EOF

   chmod 600 $server_pwdfile
}

# 建立 server 端的安裝檔
cr_installer() {
   cat <<EOF > $installer
#! /bin/bash

target=\${1:?"請提供要安裝的對象。使用法： \$0 server 或 \$0 client"}

install_to_server() {
   cp -pf ../$server_conf /etc
   cp -pf ../$server_pwdfile /etc
   if [ ! -d "$BK_SAVE/${mach}_backup" ]; then
      mkdir -p "$BK_SAVE/${mach}_backup"
   fi
}

install_to_client() {
   cp -pf ../$client_script /root
   cp -pf ../$client_pwdfile /root
   cp -pf ../$client_cron /root
}

usage() {
   echo "請提供要安裝的對象。使用法： \$0 server 或 \$0 client"
   exit 1
}

#
# 主程式區
#
case \$target in
   server)
     install_to_server
     ;;
   client)
     install_to_client
     ;;
   *)
     usage
     ;;
esac

EOF

   chmod +x $installer
}

tar_it() {
   tar cvzf $server_name.tgz $server_name
}

#
# 主程式區
#

cr_client_dir
cr_client_pwdfile
cr_crontab
cr_run_script

cr_rsync_conf
cr_rsync_pwdfile
cr_installer

tar_it
