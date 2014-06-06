#!/bin/ksh

echo ""
echo "#================= �D���W�ٸ�T ================#"
hostname
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= �@�~�t�Ϊ��� ================#"
oslevel -s
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= Java���� ====================#"
lslpp -l | grep Java | grep -v idebug | awk '{printf "%-25s %-10s\n", $1,$2}'
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= Memory ��T =================#"
prtconf -m
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= Page ��T ===================#"
lsps -a
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= �����˸m ====================#"
lsdev -C | grep ^en
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= ���ָ˸m ====================#"
lsdev -C | grep ^fcs
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= �Ϻи��| ====================#"
lspath
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= ������} ====================#"
ifconfig -a | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}'
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= ���Ѹ�T ====================#"
netstat -rn | grep -E 'en|lo' | awk '{print $1 "\t" $2}'  | grep -v '::1%1'
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= �ɮרt�� ====================#"
df -gP | grep -v "/proc" | grep -v "livedump" | awk '{print $2, "\t" $6}'
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= Mirror���A ==================#"
VGNAME=`lsvg`
for vgname in $VGNAME
do
  lsvg -l $vgname
done
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= �}������ ====================#"
bootlist -m normal -o
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= ITM agent���A ===============#"
/opt/IBM/ITM/bin/cinfo -r | grep "^`hostname`" | awk '{print $1, $2, $4, $7}'
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= CTM agent���A ===============#"
su - twse "shagent" | grep ^twse | grep -v "Password"
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================= �ϥΪ̭��� ==================#"
ulimit -a
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#============== �ϥΪ̱b���P�s��================#"
echo "�b��"
lsuser ALL | awk '{printf "%-10s %-15s %-15s %-45s %-10s\n", $1,$2,$3,$4,$5}'
echo "�s��"
lsgroup ALL | awk '{printf "%-10s %-15s %-15s %-10s\n", $1,$2,$3,$4}'
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================ �b���ޱ���T =================#"
USERLIST="root seadm se01 se02 exadm ex11 ex14 ex16 twse useradm"
for USER in $USERLIST
do
  lsuser $USER | awk '{printf "%-10s %-18s %-20s %-15s %-20s %-18s %-15s\n", $1,$23,$24,$27,$28,$37,$39}'
done
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================ /TWSE�ؿ����c ================#"
find /TWSE -type d -exec ls -ld {} \; | awk '{print $1, "\t" $3, "\t" $4, "\t" $9}'
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================ �t�κ����Ѽ� =================#"
no -a
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""

echo ""
echo "#================ �t�ΰO����Ѽ� =================#"
vmo -a | grep -v pinnable_frames
echo "#===== �T�{�W�z��T�O�_���T? Yes( ) NO( ) ======#"
echo ""
