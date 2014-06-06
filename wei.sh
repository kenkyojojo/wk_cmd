#!/usr/bin/ksh

#ssh -p 2222 -t -t $HOST >&4 2>/dev/null |&

#exec < 4

#ssh -t -t X230 >&4 > /dev/null | & << "EOF"
set -A ent en1 en2 en3

for i in ${ent[@]}
do
	echo $i
done
exit 

#TMP=$(ls -ld /tmp |awk '{print $NF}')
p1 () {
	TMP="/tmp"
}

#if [[ $flag -eq "0" ]] ;then echo zero; else echo no zero; fi

t1 () {
#set -x 
	ssh -t -t x230 << "EOF"
	flag=0
	if [[ $flag -eq "0" ]];then echo "zero" > /tmp/wei.log; else echo "no zero" > /tmp/wei.log; fi

	exit 

EOF
}

#t1 >/dev/null 2>&1
t1 
