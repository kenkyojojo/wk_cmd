#!/usr/bin/ksh

LIP="192.168.1.1"
IP="192.168.1.11 192.168.1.12 192.168.1.13 192.168.1.14"
#set -A DIP 192.168.1.11 192.168.1.12 192.168.1.1
set -A DIP $IP

MAX=${#DIP[@]}

LOSS=100

SHA=4
FAIL=4

sw=0
ha=0

main() {
#set -x 
i=1
while [ $i -le $FAIL ]
do
	j=0
	while [ $j -lt $MAX ] 
	do
		echo "ping -I $LIP ${DIP[$j]}"
		if [[ $LOSS -eq "100" ]];then
			echo "LOSS 100"	
			j=$(($j+1))
			sw=$(($sw+1))
			if [[ $sw -eq $MAX ]];then
				sw=0
				ha=$(($ha+1))
				if [[ $ha -eq $SHA ]];then
					echo "switch HA"
					exit 1
				fi
				echo "switch IB"
			fi
			continue
		fi

		if [[ $LOSS -eq "0" ]];then
			echo "Good"	
			return 0
		else
			echo "so so"
			return 0
		fi
	done
	i=$(($i+1))
done
}

swap () {
 echo 

}
main

#while f < 2
#do
#	ping ip1 
#	if  loss = 100
#		break
#	elif  loss = 0 
#		reset flag
#		return
#	elif  loss > 0 
#		errlogger 
#		return
#	fi
#
#	f++
#done
