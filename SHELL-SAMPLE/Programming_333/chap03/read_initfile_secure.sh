#!/bin/sh

# read_initfile_secure.sh - 讀入設定檔的內容(高階篇)

# 若程式的過程難以理解的話，您可以把下一行的註解拿掉
#set -x

# 若攻擊成功的話，這個函數就會被執行
danger_command() {
    echo "*** Your data has been lost... ***"
}

# 將初始設定檔讀入，並把值設定到變數中
read_init_secure() {
    while read line; do
	# 若變數名稱中有英文字母及數字以外的東西
	# 或是格式不是var=value的話，都視為錯誤
	if echo "$line" | grep -q '^[a-zA-Z][a-zA-Z0-9]*='; then         ##[A]
	    varname=`echo "$line" | sed 's/=.*//'`                       ##[B]
	    value=`echo "$line" | sed 's/^.*=//'`
	    eval "conf_${varname}=\"\$value\""                           ##[C]
	    #eval "conf_${varname}=\"$value\""  #會受到攻擊的例子
	else
	    echo "error: $line"                                          ##[D]
	fi
    done
}

# 讀入設定檔。在這裡雖然使用的是here document，
# 不過本來的話，應該是要像「read_init_source < config.file」這樣子使用。
read_init_secure <<EOF
safe=foo bar
danger1; danger_command here; =baz baz
danger2=baz baz; danger_command here
danger3=foo bar" ; danger_command here "
0invalidname=foo bar
EOF

# 顯示有做設定的變數的一覽表
set | grep '^conf_'
