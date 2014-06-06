#! /bin/bash
#
# 注意! 這支程式只適用於 C clase (含)以下的網段
#
#--------------------------------------
# 變數要先宣告後才能使用
shopt -s -o nounset

#
# 宣告區
#
ListIPcmd="/sbin/ifconfig"
Hallow="/etc/hosts.allow"
Hdeny="/etc/hosts.deny"
Services="sshd vsftpd in.qpopper"
IP=
MASK=
declare -i ip4 L U c net

#
# 函式區
#

# 取得網路遮罩用
get_mask() {
    MASK=$($ListIPcmd | grep 'Mask:' | grep -v '127.0.0.1' | awk '{print $4}' | awk -F: '{print $2}')
}

# 取得主機所在網段的網路代表號
get_netip() {
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
}


#
# 主程式區
#

get_netip

:> $Hallow
:> $Hdeny
echo "ALL: ALL" >> $Hdeny

for s in $Services
do
   echo "$s: $f3ip.$net/$MASK" >> $Hallow
done
