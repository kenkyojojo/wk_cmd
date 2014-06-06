#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

#---------------------------------------------------
# 可修改區

# 網路介面
eth="eth0"

# 網路代表路
network="192.168.1.0"

# 網路遮罩
netmask="255.255.255.0"

# 欲分配出去的 IP 段
range="192.168.1.50 192.168.1.170"

# 廣播位址
broadcast="192.168.1.255"

# 路由器
router="192.168.1.254"

# DNS Server 列表
dns="192.168.1.1, 168.95.1.1"

#---------------------------------------------------
# 設定檔
dhcp_dir="/etc/dhcp3"
dhcp_conf="$dhcp_dir/dhcpd.conf"
dhcp_default="/etc/default/dhcp3-server"
#
#---------------------------------------------------

#
# 函式區 
#

# 建立 DHCP Server 的設定檔
cr_dhcpconf() {
cat <<EOF > $dhcp_conf
#
# Sample configuration file for ISC dhcpd for Debian
#
# \$Id: gen_dhcp.sh,v 1.3 2009/06/24 02:09:33 ols3 Exp $
#

# The ddns-updates-style parameter controls whether or not the server will
# attempt to do a DNS update when a lease is confirmed. We default to the
# behavior of the version 2 packages ('none', since DHCP v2 didn't
# have support for DDNS.)
ddns-update-style none;

# option definitions common to all supported networks...
## option domain-name "example.org";
## option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 6000;
max-lease-time 72000;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
log-facility local7;

# No service will be given on this subnet, but declaring it helps the
# DHCP server to understand the network topology.

#subnet 10.152.187.0 netmask 255.255.255.0 {
#}

# This is a very basic subnet declaration.
subnet $network netmask $netmask {
range $range ;
option broadcast-address $broadcast ;
option routers $router ;
option domain-name-servers $dns ;
}

EOF

}

# 設定由哪一個網路介面配發 DHCP 組態
set_dhcp_interface() {
    [ ! -e /etc/default ] && mkdir -p /etc/default
    echo "INTERFACES=$eth" > /etc/default/dhcp3-server
}

#
# 主程式區
#

cr_dhcpconf

set_dhcp_interface

echo '完成!'
