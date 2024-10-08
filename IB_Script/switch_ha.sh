#!/usr/bin/ksh
USER=$(whoami)
NOW_HOST=$(hostname)
TYPE1A="FIXGW01P"
TYPE1B="FIXGW01B"
TYPE2A="test_ha2_1"
TYPE2B="test_ha2_2"
HADIR="/usr/es/sbin/cluster/utilities"
LOG=/tmp/switch_ha.sh.log
FIRST=1
LAST=1

#{{{tlog ,script loger function
tlog() {
    MSG=$1                                                                                                                                             LOG=$2
    dt=`date +"%y/%m/%d %H:%M:%S"`
	echo "$SITE [${dt}] $MSG" | tee  -a $LOG
} 
#}}}

#{{{errlogger to aix errpt log 
erlogger() {
	MSG=$1
	#use Rbac function.
	swrole exec.errlogger "-c errlogger $MSG"
}
#}}}


if [[ $NOW_HOST = $TYPE1A ]] || [[ $NOW_HOST = $TYPE1B ]];then
	HOSTA=$TYPE1A
	HOSTB=$TYPE1B
# Example type and ip
elif [[ $NOW_HOST = $TYPE2A ]] || [[ $NOW_HOST = $TYPE2B ]];then
	HOSTA=$TYPE2A
	HOSTB=$TYPE2B
else
	tlog "The Host type are wrong type" $LOG
#	exit 1
fi

if [[ $NOW_HOST = $HOSTA ]];then
	HOST_ALT=$HOSTB
else
	HOST_ALT=$HOSTA
fi

set -A MUSER twse bruce



#{{{ menu 
menu () {

		clear
		echo "          << FIX/FAST Power HA 操作介面 (ALL AIX LPAR) >> "
		echo ""
		echo "        1. 手動切換 Power HA 功能"
		echo ""
		echo "                                (隨時可輸 q 以離開 )"
		echo ""
		read Menu_No?"                                 請選擇選項 ($FIRST-$LAST) : "

		case $Menu_No in
			1) 
				powerha_switch
			;;
			q|Q) 
				exit 0
			;;
			*)
				echo ""
				echo "[Error]  輸入錯誤, 請輸入 ($FIRST-$LAST)的選項"
				read ANSWR?"               按Enter鍵繼續 "
				main 
			;;
		esac

}
#}}}

#{{{ switch power ha 
powerha_switch () {
#set -x 
RG_NAME_LIST=$( ${HADIR}/clRGinfo | grep RG | awk '{print $1}' 2>/dev/null )
RG_NAME=$(echo $RG_NAME_LIST | sed 's/ /,/g')
#RG_NAME=RG1
exec_status=$?
if [[ $exec_status -eq "0" ]]; then
	echo "         請確認是否將( Resourc Group:${RG_NAME} )由( Hostname:${NOW_HOST} )切換至( Hostname:${HOST_ALT} )"
	echo ""
	read ANSWER?"         請輸入(Y/N):"
	case $ANSWER in
		Y|y)
			tlog "[INFO] Resource Group:${RG_NAME} switch to ${HOST_ALT},HACMP transfer start..." $LOG
			swrole exec.clRGmove "-c ${HADIR}/clRGmove -s 'false'  -m -i -g ${RG_NAME} -n ${HOST_ALT} 2 > /dev/null"
			exec_status=$?
			if [[ $exec_status -eq "0" ]]; then
				echo ""
				tlog "		[INFO] Resource Group:${RG_NAME} switch to ${HOST_ALT},HACMP transfer completed..." $LOG
				read ANSWR?"               按Enter鍵繼續 "
				main 
			else
				echo ""
				tlog "[ERR] Resource Group:${RG_NAME} switch to ${HOST_ALT} Failed, please to check it status..." $LOG
				tlog "command：swrole exec.clRGmove "-c ${HADIR}/clRGmove -s 'false'  -m -i -g ${RG_NAME} -n ${HOST_ALT} > /dev/null 2>&1" " $LOG
				read ANSWR?"               按Enter鍵繼續 "
				main
			fi
		;;
		N|n)
			main
		;;
		*)
			echo ""
			echo "[Error]  輸入錯誤, 請輸入(Y/N)"
			read ANSWR?"               按Enter鍵繼續 "
			main 
		;;
	esac
else
	tlog "[ERR] clRGinfo command to check Resourc Group Failed...." $LOG
	read ANSWR?"               按Enter鍵繼續 "
	main
fi
}
#}}}

#{{{user_check
user_check (){
# check user information.  
	userflag=0
	for chkuser in ${MUSER[@]}
	do
		if [[ $USER = $chkuser ]];then
			userflag=1
			return 0
		fi
	done

	if [[ $userflag -eq "0" ]];then 
		return 1
	fi
}
#}}}

#{{{ main
main () {

	user_check
	exec_status=$?
	if [[ $exec_status -eq "0"  ]];then	
		menu
	else
		echo "               [Error]  $USER 無權限執行該程式"
		echo ""
		read ANSWR?"              按Enter鍵後將離開程式"
		clear
		exit 1
	fi
}
#}}}

echo "#=============================================================#" >> $LOG

main
