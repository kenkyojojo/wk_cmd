#!/usr/bin/ksh
HOST=DAP1-1
read USER?"Input NAME:"
stty -echo;
read PASS?"Input password:"
stty echo;
echo;

for HOST in $HOST
do
	for USER in $USER
	do
		 echo "Connecting to $HOST"
			 expect -c "set timeout -1;\
				 spawn ssh $HOST -l $USER \"hostname\";\
				 match_max 100000;\
				 expect *password:*;\
				 send -- $PASS\r;\
				 expect *password:*;\
				 send -- \003'\r;\
				 interact;" 
		 echo "Connecting to $HOST done"
#echo "$USER SSH Connect to the $HOST is Failed"
	done
done
