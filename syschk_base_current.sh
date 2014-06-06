#!/bin/ksh

echo ""
echo "#================= 主機名稱資訊 ================#"
hostname
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= 作業系統版本 ================#"
oslevel -s
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= Java版本 ====================#"
lslpp -l | grep Java | grep -v idebug | awk '{printf "%-25s %-10s\n", $1,$2}'
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= Memory 資訊 =================#"
prtconf -m
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= Page 資訊 ===================#"
lsps -a
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= 網路裝置 ====================#"
lsdev -C | grep ^en
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= 光纖裝置 ====================#"
lsdev -C | grep ^fcs
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= 磁碟路徑 ====================#"
lspath
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= 網路位址 ====================#"
ifconfig -a | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}'
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= 路由資訊 ====================#"
netstat -rn | grep -E 'en|lo' | awk '{print $1 "\t" $2}'  | grep -v '::1%1'
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= 檔案系統 ====================#"
df -gP | grep -v "/proc" | grep -v "livedump" | awk '{print $2, "\t" $6}'
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= Mirror狀態 ==================#"
VGNAME=`lsvg`
for vgname in $VGNAME
do
  lsvg -l $vgname
done
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= 開機順序 ====================#"
bootlist -m normal -o
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= ITM agent狀態 ===============#"
/opt/IBM/ITM/bin/cinfo -r | grep "^`hostname`" | awk '{print $1, $2, $4, $7}'
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= CTM agent狀態 ===============#"
su - twse "shagent" | grep ^twse | grep -v "Password"
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= 使用者限制 ==================#"
ulimit -a
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#============== 使用者帳號與群組================#"
echo "帳號"
lsuser ALL | awk '{printf "%-10s %-15s %-15s %-45s %-10s\n", $1,$2,$3,$4,$5}'
echo "群組"
lsgroup ALL | awk '{printf "%-10s %-15s %-15s %-10s\n", $1,$2,$3,$4}'
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================ 帳號管控資訊 =================#"
USERLIST="root seadm se01 se02 exadm ex11 ex14 ex16 twse useradm"
for USER in $USERLIST
do
  lsuser $USER | awk '{printf "%-10s %-18s %-20s %-15s %-20s %-18s %-15s\n", $1,$23,$24,$27,$28,$37,$39}'
done
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================ /TWSE目錄結構 ================#"
find /TWSE -type d -exec ls -ld {} \; | awk '{print $1, "\t" $3, "\t" $4, "\t" $9}'
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================ 系統網路參數 =================#"
no -a
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================ 系統記憶體參數 =================#"
vmo -a | grep -v pinnable_frames
echo "#===== 確認上述資訊是否正確? Yes( ) NO( ) ======#"
echo ""
