#! /bin/bash

shopt -s -o nounset
ACTno=${1:?'錯誤! 請提供欲建立的帳號數!'}
PKey=''
ACT=''
ACTprefix='stu'
ACTlist='accounts.txt'
declare -i k okact=0

#
# 函式區
#

# 產生隨機的字串
gen_key() {
    KeyLen=${1:?'錯誤! 請提供欲產生的字串長度!'}
    declare -i N I
    declare -i KeyLen
    PKey=''
    AFB='ABCDEFGHIJKLM;0123456789#abcdefghijk_NOPQRSTUVWXYZ;mnopqrstuvwxyz^0123456789_abcdefghijk#0123456789;mnopqrstuvwxyz_ABCDEFGHIJKLM^0123456789'
    for ((I=0; I<KeyLen; I++)) 
    do
        N=$(head -1 /dev/urandom | od -N 2 | head -1 | awk '{print $2 * 1}')
	    ((N%=${#AFB}))
        PKey=$PKey${AFB:$N:1}
    done
}


#
# 主程式區
#

echo "-------------------------------------" >> $ACTlist

for ((k=1; k<=$ACTno; k++))
do
    ACT="$ACTprefix$k"
    gen_key 6
    adduser --quiet --disabled-password --gecos '' $ACT
    if [ $? -eq 0 ]; then
       echo "$ACT:$PKey" | chpasswd
       echo "帳號: $ACT | 密碼: $PKey" >> $ACTlist
       echo "-------------------------------------" >> $ACTlist
       ((okact++))
       echo "帳號 $ACT 建立完成 ...."
    fi
done

echo "共建立了 $okact 個帳號."
echo "請查看 $ACTlist 這個檔案."
