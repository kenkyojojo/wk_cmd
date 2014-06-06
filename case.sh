#!/usr/bin/ksh
#hostname=list
#hostname="[dap1-30]"
hostname="dap1-30 dap2-1 dap2-40 WKLPAR"
#hostname=dap1-30 dap2-1
#set -A hostname dap1-30 dap1-1

for hostname in ${hostname[@]}
do
	case $hostname in 
		dap*)
			echo "1 $hostname"
		;;
		*)
			echo "2 $hostname"
		;;

	esac
done
