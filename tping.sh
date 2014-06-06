#!/usr/bin/ksh
COUNT=3
INTERVAL=2
LOSSCOUNT=0
set -A DESIP "192.168.1.2"  "tw.yahoo.com"
LOSSPERCENT=20

alarm() {
	  perl -e '
      eval {
        $SIG{ALRM} = sub { die };
        alarm shift;
        system(@ARGV);
	    };
	      if ($@) { exit 1 }
	    ' "$@";
}

ping_check(){
	DESIP=$1
	ping -q -c $COUNT -w 1 $DESIP | grep loss | cut -d '%' -f 1 | awk '{print $NF}'
}

main() {
	for desip in ${DESIP[@]}
	do
		LOSS=$(ping_check $desip)
		if [[ $LOSS -gt $LOSSPERCENT ]];then
			echo "Target: ${desip} Please to be careful ib network,packet loss ${LOSS}%."
			LOSSCOUNT=$(( $LOSSCOUNT + 1 ))
		else
			echo "Target: ${desip} The network status is Perfect."
			LOSSCOUNT=0
		fi

		if [[ $LOSSCOUNT -eq $COUNT ]];then
			echo "Target: ${desip} The network status count 3 times has fail."
		fi
	done
}

begin () {
rflag=1
while (true)
do
	if [[ $rflag -gt $COUNT ]];then
		echo $rflag
		exit  0
	fi

	main
	sleep $INTERVAL

	rflag=$(( $rflag + 1 ))
done
}
begin
