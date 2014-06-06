#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

#
# 宣告區
#

ListIPcmd="/sbin/ifconfig"
# 欲產生的 iptables 設定檔
RC="rc.local"
# 主機 IP
IP=
# 網路代表號
NET=
# 網路代表號/連續 bit 是 1 的位元數，比如 192.168.1.0/24
NETWORK=
# 網路遮罩
MASK=
# 連續 bit 是 1 的位元數
MASKBITS=
# 二進位各位元的冪值列表
masklist="128 64 32 16 8 4 2 1"
# 保存分隔字元串列的內容
Save_IFS=$IFS

#
# 函式區
#

trans_bits() {
    local a i q s
    declare -i a i q s=0
    # a 是傳入的整數，小於或等於 255
    a=$1
    # 恢復預設的分隔字元串例
    IFS=$Save_IFS
    # 將 a 代成二進位數，計算其 bit 是 1 的個數
    for i in $masklist
    do
        # q 是 a 除以各位元冪值的商，比如 255/128 得商為 1
        q=$((a/i))
        # s 用以統計 bit 是 1 的個數
        ((s+=q))
        # 更新 a 的值，比如 255 - 128*1 = 127，再進入下一個迴圈
        a=$((a-q*i))
    done
    # 傳回 bit 是 1 的個數
    return $s
}

get_bit1() {
    local i mask
    declare -i i mask

    # 因為網路遮罩以 '.' 分隔，所以，將分隔字元變數設為 '.'
    # 如此，可抽出網路遮罩的四個數字
    IFS='.'
    for i in $1
    do
        # 將網路遮罩的每一個數字，傳入 trans_bits 函式，計算 bit 是 1 的個數
        trans_bits $i
        # mask 統計 bit 是 1 的總個數
        ((mask+=$?))
    done
    # 恢復分隔字元變數的內容
    IFS=$Save_IFS
    # 傳回 bit 是 1 的總個數
    return $mask
}

# 取得網路遮罩
get_mask() {
    # MASK 為網路遮罩，比如 255.255.255.0
    MASK=$($ListIPcmd | grep 'Mask:' | grep -v '127.0.0.1' | awk '{print $4}' | awk -F: '{print $2}')
}

# 取得網路遮罩位元數
get_mask_bits() {
    # MASK 為網路遮罩，比如 255.255.255.0
    if [ -z "$MASK" ]; then
       MASK=$($ListIPcmd | grep 'Mask:' | grep -v '127.0.0.1' | awk '{print $4}' | awk -F: '{print $2}')
    fi
    # 叫用 get_bit1 計算位元值為 1 的個數
    get_bit1 "$MASK"
    return $?
}

# 取得主機所在網段的網路代表號
get_netip() {
    local ip4 f3ip mask4 L U c net
    declare -i mask4 L U c net

    IP=$($ListIPcmd | grep 'inet addr:' | grep -v '127.0.0.1' | awk '{print $2}' | awk -F: '{print $2}')

    # IP 的第 4 個數字，比如 192.168.1.78 的 78
    ip4=${IP##*.}

    # IP 的前 3 個數字，比如 192.168.1.78 的 192.168.1
    f3ip=${IP%.*}    

    # 取得目前網卡的網路遮罩
    get_mask

    # 網路遮罩的第 4 個數字，比如 255.255.255.192 的 192
    mask4=${MASK##*.}

    # L 同 mask4，比如 192
    L=mask4

    # U 為主機所屬網段可用 IP 數，比如 256-192=64
    U=256-L

    # 計算主機的 IP 是落在哪一個網段，比如 78/64 取整數得 c=1，為第 2 個網段(0算第一個網段)
    c=ip4/U
   
    # 網段代表號，比如 64*1=64，表示第 2 個網段的代表號為 x.x.x.64
    net=U*c
    NET=$f3ip.$net
}


gen_iptables() {
  cat <<EOF > $RC
#! /bin/bash
#
# iptables 範本
# written by OLS3 (ols3@lxer.idv.tw)
#
# 請自行參考修改，把註解拿掉即可啟用該項設定
#

#/sbin/route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.1

###-----------------------------------------------------###
# 設定 iptables 的路徑
###-----------------------------------------------------###
echo "Set path of iptables"
echo

IPTABLES="/sbin/iptables"

#/sbin/modprobe ip_conntrack
#/sbin/modprobe ip_conntrack_ftp
#/sbin/modprobe iptable_nat
#/sbin/modprobe ip_nat_ftp

###-----------------------------------------------------###
# 外部網段 IP 及介面
###-----------------------------------------------------###
echo "Set external ......"
echo

FW_IP="$IP"
FW_IP_RANGE="$NETWORK"
#FW_IFACE="eth0"

###-----------------------------------------------------###
# 設定內部網段 IP 及介面
###-----------------------------------------------------###
echo "Set internal ......"
echo

#LAN_IP="192.168.1.1"
#LAN_IP_RANGE="192.168.1.0/24"
#LAN_BCAST_ADRESS="192.168.1.255"
#LAN_IFACE="eth1"

# loopback interface
LO_IFACE="lo"
LO_IP="127.0.0.1"



###-----------------------------------------------------###
# 打開 forward 
###-----------------------------------------------------###
#echo "Enable ip_forward ......"
#echo

#echo "1" > /proc/sys/net/ipv4/ip_forward


###-----------------------------------------------------###
# 清除先前的設定
###-----------------------------------------------------###
echo "Flush fiter table ......"
echo

# Flush filter
\$IPTABLES -F
\$IPTABLES -X

echo "Flush mangle table ......"
echo
# Flush mangle
\$IPTABLES -F -t mangle
\$IPTABLES -t mangle -X


echo "Flush nat table ......"
echo
# Flush nat
\$IPTABLES -F -t nat
\$IPTABLES -t nat -X

###-----------------------------------------------------###
# 設定 filter table 的預設政策
###-----------------------------------------------------###
\$IPTABLES -P INPUT ACCEPT
\$IPTABLES -P OUTPUT ACCEPT
\$IPTABLES -P FORWARD ACCEPT

###-----------------------------------------------------###
# 啟動內部對外轉址
###-----------------------------------------------------###

#\$IPTABLES -t nat -A POSTROUTING -o \$FW_IFACE -j SNAT --to-source \$FW_IP

###-----------------------------------------------------###
# 啟動外部對內部轉址
###-----------------------------------------------------###
# 凡對 \$FW_IP:8080 連線者, 則轉址至 192.168.1.3:80
#\$IPTABLES -t nat -A PREROUTING -p tcp -d \$FW_IP --dport 8080  -j DNAT --to 192.168.1.3:80

###-----------------------------------------------------###
# 拒絕某一內部 IP 使用某一通道
###-----------------------------------------------------###

# 以下封掉內部主機連到外部主機的 port 6677, 請自行針對不同服務 port 號做修改
# 讓 192.168.1.6 通過
#\$IPTABLES -A FORWARD -o \$FW_IFACE -p tcp -s 192.168.1.6 --dport 6677 -j ACCEPT
# 其餘擋掉
#\$IPTABLES -A FORWARD -o \$FW_IFACE -p tcp --dport 6677 -j DROP

###-----------------------------------------------------###
# 拒絕外部 IP 連至內部 port 號
###-----------------------------------------------------###

# 以下擋掉外部主機連至內部主機 port 6677
# 讓 192.168.1.0/24 通過
#\$IPTABLES -A INPUT -i \$FW_IFACE -p tcp -s 192.168.1.0/24 --dport 6677 -j ACCEPT
# 其餘擋掉
#\$IPTABLES -A INPUT -i \$FW_IFACE -p tcp --dport 6677 -j DROP

# 只有本主機所屬網段才能連到這台主機的 FTP server port 21
\$IPTABLES -A INPUT -p tcp -s $NETWORK --dport 21 -j ACCEPT
\$IPTABLES -A INPUT -p tcp -s 127.0.0.1 --dport 21 -j ACCEPT
\$IPTABLES -A INPUT -p tcp --dport 21 -j DROP

# 只有本主機所屬網段才能連到這台主機的 Telnet server port 23
\$IPTABLES -A INPUT -p tcp -s $NETWORK --dport 23 -j ACCEPT
\$IPTABLES -A INPUT -p tcp -s 127.0.0.1 --dport 23 -j ACCEPT
\$IPTABLES -A INPUT -p tcp --dport 23 -j DROP

# 只有本主機所屬網段才能連到這台主機的 ssh port 22
\$IPTABLES -A INPUT -p tcp -s $NETWORK --dport 22 -j ACCEPT
\$IPTABLES -A INPUT -p tcp -s 127.0.0.1 --dport 22 -j ACCEPT
\$IPTABLES -A INPUT -p tcp --dport 22 -j DROP

# 只有本主機所屬網段才能連到這台主機的 imap port 143
\$IPTABLES -A INPUT -p tcp -s $NETWORK --dport 143 -j ACCEPT
\$IPTABLES -A INPUT -p tcp -s 127.0.0.1 --dport 143 -j ACCEPT
\$IPTABLES -A INPUT -p tcp --dport 143 -j DROP

# 只有本主機所屬網段才能連到這台主機的 imaps port 993
\$IPTABLES -A INPUT -p tcp -s $NETWORK --dport 993 -j ACCEPT
\$IPTABLES -A INPUT -p tcp -s 127.0.0.1 --dport 993 -j ACCEPT
\$IPTABLES -A INPUT -p tcp --dport 993 -j DROP

# 只有本主機所屬網段才能連到這台主機的 Samba port tcp 139,445 / udp 137,138
\$IPTABLES -A INPUT -p tcp -s $NETWORK --dport 139 -j ACCEPT
\$IPTABLES -A INPUT -p tcp -s $NETWORK --dport 445 -j ACCEPT
\$IPTABLES -A INPUT -p udp -s $NETWORK --dport 137 -j ACCEPT
\$IPTABLES -A INPUT -p udp -s $NETWORK --dport 138 -j ACCEPT
\$IPTABLES -A INPUT -p tcp -s 127.0.0.1 --dport 139 -j ACCEPT
\$IPTABLES -A INPUT -p tcp -s 127.0.0.1 --dport 445 -j ACCEPT
\$IPTABLES -A INPUT -p udp -s 127.0.0.1 --dport 137 -j ACCEPT
\$IPTABLES -A INPUT -p udp -s 127.0.0.1 --dport 138 -j ACCEPT
\$IPTABLES -A INPUT -p tcp --dport 139 -j DROP
\$IPTABLES -A INPUT -p tcp --dport 445 -j DROP
\$IPTABLES -A INPUT -p udp --dport 137 -j DROP
\$IPTABLES -A INPUT -p udp --dport 138 -j DROP

/sbin/ip6tables -F
/sbin/ip6tables -A INPUT -p tcp --dport 21 -j DROP
/sbin/ip6tables -A INPUT -p tcp --dport 22 -j DROP
/sbin/ip6tables -A INPUT -p tcp --dport 23 -j DROP
/sbin/ip6tables -A INPUT -p tcp --dport 139 -j DROP
/sbin/ip6tables -A INPUT -p tcp --dport 445 -j DROP
/sbin/ip6tables -A INPUT -p udp --dport 137 -j DROP
/sbin/ip6tables -A INPUT -p udp --dport 138 -j DROP


EOF

}

#
# 主程式區
#

# 取得網路代表號 NET 和 IP 
get_netip

# 取得網路遮罩連續位元為 1 的數目，比如 255.255.255.0 為 24 bits，
# 255.255.255.128 為 25 bits，255.255.255.192 為 26 bits。
get_mask_bits

# 取得 get_mask 的傳回值
MASKBITS=$?

NETWORK=$NET/$MASKBITS

# 建立 iptables 設定檔
gen_iptables
