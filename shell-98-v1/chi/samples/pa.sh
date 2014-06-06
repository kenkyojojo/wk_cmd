#! /bin/bash

# 變數要先宣告後才能使用
shopt -s -o nounset

HostList=${1:?'請提供主機IP列表檔!'}

[ ! -f $HostList ] && echo '主機IP列表檔不存在喔! 請檢查一下先!' && exit 1

# 日期時間
Date=$(date +'%Y%m%d%H%M')
Date_for_man=$(date +'%Y-%m-%d %H 時 %M 分')

# ping 的次數
pno=4

# 偵測結果存檔
padir="/var/www/pa"
pahtml="$padir/index.html" 
pahtml_now="$padir/pa-$Date.html"

#
# 函式區
#

html_head() {
[ ! -e $padir ] && mkdir -p $padir
cat <<HEAD > $pahtml_now
<html>
<head>
<title>ping alive 偵測結果</title>
<meta HTTP-EQUIV="Refresh" CONTENT="900">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Cache-Control" content="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="Mon, 01 Jul 2000 06:00:13 GMT">
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body bgcolor="white">
<div align=center><font size=6><b>*** 我的主機監控 ***</b></font></div>
<div align=center>偵測時間： $Date_for_man</div>
<p>
<table width="60%" align=center border=3>
<tr><td nowrap>主機名稱</td><td>IP</td><td nowrap>最小反應時間</td><td nowrap>最大反應時間</td><td nowrap>平均反應時間</td></tr>
HEAD

}

html_tr() {
if [ "$1" = "PingError" ]; then
   cat <<TR >> $pahtml_now
<tr><td>$host</td><td>$ip</td><td colspan=3><font color=red><b>無法連通!!!</b></font></td></tr>
TR

else
   cat <<TR >> $pahtml_now
<tr><td>$host</td><td>$ip</td><td>$rt_min ms</td><td>$rt_max ms</td><td>$rt_avg ms</td></tr>
TR

fi
}

html_end() {
cat <<END >> $pahtml_now
</table>
</body>
</html>
END

ln -sf $pahtml_now $pahtml
}

#
# 主程式區
#

# 建立偵測結果網頁的檔頭
html_head

# 處理迴圈
#-----------------------------------------------------------------------
while read host ip
do
    rt_min=
    rt_avg=
    rt_max=
    while read r
    do
        if [[ $r == round-trip* ]]; then
           rt_min=$(echo $r | awk '{print $4}' | awk -F/ '{print $1}')
           rt_avg=$(echo $r | awk '{print $4}' | awk -F/ '{print $2}')
           rt_max=$(echo $r | awk '{print $4}' | awk -F/ '{print $3}')
           html_tr $rt_min $rt_avg $rt_max
        fi 
    done < <(ping -c $pno $ip)
    if [ -z $rt_min ]; then
           html_tr PingError
    fi
done < <(cat $HostList)
#-----------------------------------------------------------------------

# 建立偵測結果網頁的檔尾
html_end
