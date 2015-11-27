#!/usr/bin/ksh

#{{{ Parameter setting
SITE="TSEOB1"
USER=$(whoami)
LOGDIR="/var/hacmp/log"
LOG="${LOGDIR}/ha_start_stop.sh.log"
HOSTNAME=$(hostname)
#FIXGW01
FIXGW01P_ib0="192.168.1.1"
FIXGW01P_ib1="192.168.3.3"
FIXGW01B_ib0="192.168.2.2"
FIXGW01B_ib1="192.168.4.4"
#FIXGW02
FIXGW02P_ib0="192.168.5.5"
FIXGW02P_ib1="192.168.7.7"
FIXGW02B_ib0="192.168.6.6"
FIXGW02B_ib1="192.168.8.8"

set -A LOGIC_IB ib0 ib1
set -A MUSER root 
#}}}

#{{{tlog ,script loger function
tlog() {

    MSG=$1
    LOG=$2
	dt=$(date +"%Y/%m/%d %H:%M:%S")

	echo "$SITE [${dt}] $MSG" | tee  -a $LOG

	rc=$?
	if [[ $rc -ne "0" ]]; then
		echo "Please to check the LOG:$LOG"
		return 1
	else 
		return 0
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

#{{{init the ib ip use chdev
init_ib_ip () {

		tlog "Detach ib0 start" $LOG
		chdev -l ib0 -a state=detach > /dev/null 2>>$LOG
		rc=$?
		if [[ $rc -ne "0" ]]; then
			tlog "Please to check the ib0 ip" $LOG
			return 1
		else 
			tlog "Detach ib0 finished and successed" $LOG
			return 0
		fi
}

#}}}

#{{{Detach ib interface
detach() {
#set -x 
#tlog "#==========================detach_...================================================#" $LOG

  tlog "[INFO] Detaching ib device..." $LOG

  # detach the ib0 
  # use Rbac function, detach ib
  for logic_ib in ${LOGIC_IB[@]}
  do
    chdev -l $logic_ib -a state=detach > /dev/null 2>>${LOG}.${today}
    exec_status=$?
    if [[ $exec_status -eq "0" ]];then
      tlog "[INFO] Detach $logic_ib success" $LOG
    else 
      tlog "[INFO] Detach $logic_ib failed" $LOG
    fi
  done
}
#}}}

#{{{Bind dummy ip on ib interface
bind_dummy_ip () {
#set -x 
#tlog "#==========================detach_...================================================#" $LOG

  tlog "[INFO] Bind dummy ip on ib device..." $LOG

  # Bind dummy ip 
	case $HOSTNAME in 
		FIXGW01P)
		  port_num=1
		  for logic_ib in ${LOGIC_IB[@]}
		  do
			  eval "chdev -l $logic_ib -a ib_adapter=iba0 -a ib_port=${port_num} -a state=up -a netaddr=\$${HOSTNAME}_${logic_ib} -a netmask=255.255.255.0 > /dev/null 2>>${LOG}.${today}"
			  exec_status=$?
			  if [[ $exec_status -eq "0" ]];then
      			tlog "[INFO] Bind dummy $logic_ib success" $LOG
			  else 
      			tlog "[Err] Bind dummy $logic_ib failed" $LOG
			  fi
			  port_num=$(($port_num + 1 ))
		  done
  			;;
		FIXGW01B)
		  port_num=1
		  for logic_ib in ${LOGIC_IB[@]}
		  do
			  eval chdev -l $logic_ib -a ib_adapter=iba0 -a ib_port=${port_num} -a state=up -a netaddr=\$${HOSTNAME}_${logic_ib} -a netmask=255.255.255.0 > /dev/null 2>>${LOG}.${today}
			  exec_status=$?
			  if [[ $exec_status -eq "0" ]];then
      			tlog "[INFO] Bind dummy $logic_ib success" $LOG
			  else 
      			tlog "[Err] Bind dummy $logic_ib failed" $LOG
			  fi
			  port_num=$(($port_num + 1 ))
		  done
  			;;
		FIXGW02P)
		  port_num=1
		  for logic_ib in ${LOGIC_IB[@]}
		  do
			  eval chdev -l $logic_ib -a ib_adapter=iba0 -a ib_port=${port_num} -a state=up -a netaddr=\$${HOSTNAME}_${logic_ib} -a netmask=255.255.255.0 > /dev/null 2>>${LOG}.${today}
			  exec_status=$?
			  if [[ $exec_status -eq "0" ]];then
      			tlog "[INFO] Bind dummy $logic_ib success" $LOG
			  else 
      			tlog "[Err] Bind dummy $logic_ib failed" $LOG
			  fi
			  port_num=$(($port_num + 1 ))
		  done
  			;;
		FIXGW02B)
		  port_num=1
		  for logic_ib in ${LOGIC_IB[@]}
		  do
			  eval chdev -l $logic_ib -a ib_adapter=iba0 -a ib_port=${port_num} -a state=up -a netaddr=\$${HOSTNAME}_${logic_ib} -a netmask=255.255.255.0 > /dev/null 2>>${LOG}.${today}
			  exec_status=$?
			  if [[ $exec_status -eq "0" ]];then
      			tlog "[INFO] Bind dummy $logic_ib success" $LOG
			  else 
      			tlog "[Err] Bind dummy $logic_ib failed" $LOG
			  fi
			  port_num=$(($port_num + 1 ))
		  done
  			;;
         *)
          tlog "[ERR] LPAR Name is not correct" $LOG
          aptlog "E" "LPAR Name is not correct" $APLOG
         ;;
    esac
}
#}}}

#{{{step:1 , main
main () {
		echo "\n" | tee -a $LOG
		tlog "***************************InfiniBand init ip begins**********************************" $LOG
		#check exec user is twse
		user_check
		rc=$?
		if [[ $rc -eq "0"  ]];then	
		    detach
			rc=$?
			if [[ $rc -eq "0" ]];then
			  bind_dummy_ip
			else
			  tlog "[ERR] Detach ib interface failed, than $0 script terminated" $LOG
			  exit 1
		    fi
		else
			tlog "[ERR] $USER permission denied, than $0 script terminated" $LOG
			exit 1
		fi
}
#}}}

main

exit 0
