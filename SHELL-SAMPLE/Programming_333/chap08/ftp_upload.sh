#!/bin/sh

# ftp_upload.sh - 使用ftp來上傳檔案

# show_help
#     顯示求助檔的函數
show_help() {
    cat <<'EOF'
usage: ftp_upload.sh [options...] ftp_host remote_dir files ...
options:
  -u user      set FTP login name.
  -p password  set FTP login password.
  -P           toggle passive mode.
  -h           show this help message.
EOF
}

# 調查echo指令的相容性
if [ "`echo '\c'`" = "\c" ]; then
    ECHO_N=-n
    ECHO_C=
else
    ECHO_N=
    ECHO_C="\c"
fi

# 調查test指令的相容性
if /bin/sh -c '[ 1 -lt 2]' 2>/dev/null; then
    command=""
else
    command="command"
fi

# 初始設定
ftp_user=`whoami`
ftp_pass=
toggle_passive="NO"

# 調查命令列選項
while getopts 'u:p:Ph' flag; do
    case $flag in
	u)
	    ftp_user=$OPTARG
	    ;;
	p)
	    ftp_pass=$OPTARG
	    ;;
	P)
	    toggle_passive="YES"
	    ;;
	*)
	    show_help
	    exit 1
    esac
done
shift `expr $OPTIND - 1`

# 除了選項之外，至少需要3個引數
if $command [ $# -lt 3 ]; then
    show_help
    exit 1
fi

ftp_host=$1
ftp_dir=$2
shift 2

# 若沒有指定密碼的話，詢問密碼
if [ -z "$ftp_pass" ]; then
    stty -echo
    echo $ECHO_N "Enter FTP password: $ECHO_C"
    read ftp_pass
    stty echo
    echo
fi

# 製作expect的script
expect_script="#expect script開始

set timeout 20
set ftp_host \"${ftp_host}\"
set ftp_dir \"${ftp_dir}\"
set toggle_passive \"${toggle_passive}\"
set ftp_user \"${ftp_user}\"
set ftp_pass \"${ftp_pass}\"
array set files {"

# 回到shell script
for local_file do  # 將欲傳送的檔案一覽表存到陣列去
    remote_file=`basename "${local_file}"`
    expect_script="${expect_script}
  \"${remote_file}\" \"${local_file}\""
done
# 回到expect

expect_script="${expect_script}
}

#雙引號到這裡結束
"'
#單引號從這裡開始

spawn ftp $ftp_host

expect {
  "ftp>" { exit 1 }      ;#無法連線
  "Name "
}
send "$ftp_user\r"

expect "Password:"
send "$ftp_pass\r"
expect {
  "230 " { }
  "ftp>" { exit 1 }      ;#密碼不對
}

if { $toggle_passive == "YES" } {
  expect "ftp>"
  send "passive\r"   ;# 有必要的話開passive模式
}

expect "ftp>"
send "cd \"$ftp_dir\"\r"
expect {
  "250 " { }
  "ftp>" { exit 1 }      ;#無法使用cd
}

# 傳送檔案
set timeout -1       ;# 傳送時不做timeout監視
foreach remote_file [array names files] {
  set local_file $files($remote_file)
  expect "ftp>"
  send "put \"$local_file\" \"$remote_file\"\r"
}

# 連線結束
expect "ftp>"
send "quit\r"
expect eof

#expect script結束
'

expect -c "${expect_script}"
