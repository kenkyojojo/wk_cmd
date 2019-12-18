#!/bin/ksh
HOSTNAME=`hostname`
DT=`date +'%Y%m%d'`
HADIR="/usr/es/sbin/cluster/utilities"
#
HOSTDIR="/etc"
HSOTFILE="${HOSTDIR}/hosts"
#
RHOSTDIR="/etc/cluster"
RHSOTFILE="${RHOSTDIR}/rhosts"
SHDIR="/home/se/safechk/safesh"
LOGFILE="/home/se/safechk/safelog/${0}.log"
FIXGW01_SRV="FIXGW01P_SRV1"
FIXGW02_SRV="FIXGW02P_SRV1"
OTCFIXGW01_SRV="OTCFIXGW01P_SRV1"
OTCFIXGW02_SRV="OTCFIXGW02P_SRV1"
# ret
HSOTFILERET="${HOSTDIR}/hosts.reset"
RHSOTFILERET="${RHOSTDIR}/rhosts.reset"
MSI1_ip_ret="1.1.1.1"
MSI2_ip_ret="1.1.1.2"
OTCMSI1_ip_ret="1.1.1.3"
OTCMSI2_ip_ret="1.1.1.4"
FIXGW01P_bootip_ret="1.1.1.5"
FIXGW01B_bootip_ret="1.1.1.6"
FIXGW02P_bootip_ret="1.1.1.7"
FIXGW02B_bootip_ret="1.1.1.8"
OTCFIXGW01P_bootip_ret="1.1.1.9"
OTCFIXGW01B_bootip_ret="1.1.1.10"
OTCFIXGW02P_bootip_ret="1.1.1.11"
OTCFIXGW02B_bootip_ret="1.1.1.12"
# chg
HSOTFILECHG="${HOSTDIR}/hosts.change"
RHSOTFILECHG="${RHOSTDIR}/rhosts.change"
MSI1_ip_chg="1.1.2.1"
MSI2_ip_chg="1.1.2.2"
OTCMSI1_ip_chg="1.1.2.3"
OTCMSI2_ip_chg="1.1.2.4"
FIXGW01P_bootip_chg="1.1.2.5"
FIXGW01B_bootip_chg="1.1.2.6"
FIXGW02P_bootip_chg="1.1.2.7"
FIXGW02B_bootip_chg="1.1.2.8"
OTCFIXGW01P_bootip_chg="1.1.2.9"
OTCFIXGW01B_bootip_chg="1.1.2.10"
OTCFIXGW02P_bootip_chg="1.1.2.11"
OTCFIXGW02B_bootip_chg="1.1.2.12"

$tlog=${SHDIR}/tlog.sh

# $tlog "$HOST " $LOGFILE

change_MIS () {

 $tlog "Change ip start" $LOGFILE
	case  $HOSTNAME in
		MIS1)
 			$tlog "$HOST change ip start" $LOGFILE
				chdev -l en1 -a netaddr=$MIS1_ip_chg -a state=up
 			$tlog "$HOST change ip finish" $LOGFILE
		;;

 		*)

		;;

	esac

 $tlog "$HOST change ip finish" $LOGFILE

}

change_FIXGW () {
	case  $HOSTNAME in
		FIXGW01P)
			stopsrc -s clcomd 
			cp $HOSTFILE $HOSTFILE
			${HADIR}/clmgr mod service_ip $FIXGW01_SRV name=${FIXGW01_SRV}
			chdev -l en1 -a netaddr="1.1.1.1" -a state="up"
			sleep 2
			startsrc -s clcomd 
		;;

	esac
}


case $HOSTNAME in
	MIS1)
	  MIS
	  ;;
	OTCMIS1)
	  MIS
	  ;;
	FIXGW01P)
	  FIXGW
	  ;;
	FIXGW01B)
	  FIXGW
	  ;;
	FIXGW02P)
	  FIXGW
	  ;;
	FIXGW02B)
	  FIXGW
	  ;;
	OTCFIXGW01P)
	  FIXGW
	  ;;
	OTCFIXGW01B)
	  FIXGW
	  ;;
	OTCFIXGW02P)
	  FIXGW
	  ;;
	OTCFIXGW02B)
	  FIXGW
	  ;;
	*)
	  manage_VLAN
	  ;;
esac

cat  $LOGFILE
