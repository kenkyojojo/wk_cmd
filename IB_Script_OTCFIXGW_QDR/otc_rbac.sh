#!/usr/bin/ksh
LOG=/tmp/otc_rbac.sh.log
#ROLES="exec.chdev exec.errlogger exec.clRGmove exec.mkiba exec.mkdev"
#ROLES="exec.chdev exec.errlogger exec.clRGmove exec.mkiba "
ROLES="exec.chdev exec.errlogger exec.clRGmove"


#{{{tlog
tlog() {
	MSG=$1
	LOG=$2
	dt=`date +"%y/%m/%d %H:%M:%S"`
	echo "$SITE [${dt}] $MSG" | tee  -a $LOG
}        
#}}}

#{{{mk_pubic_auth
mk_pubic_auth(){
	mkauth dfltmsg='TWSE custom' TWSE
	mkauth dfltmsg='TWSE custom application' TWSE.app
	mkauth dfltmsg='TWSE custom application execute' TWSE.app.exec
}
#}}}

#{{{mk_prive_auth
mk_prive_auth(){
	mkauth dfltmsg="Custom role to run mkiba command ha command execute clRGmove"  TWSE.app.exec.clRGmove
	#mkauth dfltmsg="Custom role to run mkiba command  with otc user"  TWSE.app.exec.mkiba
}
#}}}

#{{{set_pv_attr
set_pv_attr(){
#add new command clRGmove
	setsecattr -c innateprivs=PV_PROC_PRIV,PV_KER_ACCT,PV_NET_CNTL,PV_NET_PORT secflags=FSF_EPS accessauths=TWSE.app.exec.clRGmove  euid=0 /usr/es/sbin/cluster/utilities/clRGmove
# add PV_ROOT privilege on chdev command 
	setsecattr -c innateprivs=+PV_ROOT inheritprivs=+PV_ROOT /usr/sbin/chdev

#mkiba
#setsecattr -c innateprivs=PV_DAC_O,PV_PROC_PRIV,PV_KER_ACCT,PV_PROC_PRIV,PV_KER_ACCT secflags=FSF_EPS accessauths=TWSE.app.exec.mkiba  /usr/sbin/mkiba
}
#}}}

#{{{chk_pv_attr
chk_pv_attr(){
	tlog "`lssecattr -F -c /usr/es/sbin/cluster/utilities/clRGmove`" $LOG
#tlog "`lssecattr -F -c /usr/sbin/mkiba`" $LOG
}
#}}}

#{{{mk_role
mk_role(){
#	mkrole authorizations=aix.device.manage.create dfltmsg="Custom role to run mkdev command  with otc user" exec.mkdev
#	mkrole authorizations=TWSE.app.exec.mkiba dfltmsg="Custom role to run mkiba command  with otc user" exec.mkiba
	mkrole authorizations=aix.device.manage.change dfltmsg="Custom role to run chdev  command  with otc user" exec.chdev
	mkrole authorizations=aix.ras.error dfltmsg="Custom role to run errlogger  command  with otc user" exec.errlogger
	mkrole authorizations=TWSE.app.exec.clRGmove  dfltmsg="Custom role to run clRGmove command  with otc user" exec.clRGmove 
}
#}}}

#{{{update_kernel
update_kernel(){
	setkst
}
#}}}

#{{{ch_user
ch_user(){
#chuser roles=exec.chdev,exec.errlogger,exec.clRGmove,exec.mkiba,exec.mkdev otc
#chuser roles=exec.chdev,exec.errlogger,exec.clRGmove,exec.mkiba otc
		chuser roles=exec.chdev,exec.errlogger,exec.clRGmove otc
}
#}}}

#{{{ls_user
ls_user(){
	tlog "`lsuser -a roles otc`" $LOG
}
#}}}

#{{{ch_role
ch_role(){
	for roles in $ROLES
	do
		chrole "auth_mode=NONE" ${roles}
	done
}
#}}}

#{{{ls_role
ls_role(){
	for roles in $ROLES
	do
		tlog "`lsrole -c -a auth_mode $roles`" $LOG
	done
}
#}}}

#{{{rm_pv_attr
rm_pv_attr(){
#clRGmove
	rmsecattr -c  /usr/es/sbin/cluster/utilities/clRGmove
#mkiba
#	rmsecattr -c  /usr/sbin/mkiba
}
#}}}

#{{{rm_prive_auth
rm_prive_auth(){
	rmauth -h TWSE
}
#}}}

#{{{rm_role
rm_role(){
	for roles in $ROLES
	do
		rmrole $roles
	done
}
#}}}

#{{{rm_auth
rm_auth(){
	rmauth -h TWSE
}
#}}}

#{{{main
main (){
	tlog "#==========================================================#" $LOG
	if [[ -z $1 ]];then
		mk_pubic_auth
		mk_prive_auth
		set_pv_attr
		chk_pv_attr
		mk_role
		ch_role
		ls_role
		update_kernel
		ch_user
		ls_user
	fi

	if [[ $1 = "rm" ]];then
		rm_pv_attr
		rm_prive_auth	
		rm_auth
		rm_role
		ls_user
	fi
}
#}}}

main $1
