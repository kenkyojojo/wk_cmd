#!/usr/bin/ksh 

#To choose which Lpar id you want to active,you need to type 2 lpar_id number. 
#First number is you want active First lpar_id number,second number is the last number you want to close lpar_id id.
#It will scp 2 file to HMC , and you need to type the passwd for hscroot.
#hmc-borrow
HMC=10.199.131.251
TOTLE=96
main () {
clear ""
print "You can type q or Q exit the shell"
#set First LPAR_ID
read FNUM?"Please input the you want to active First LPAR_ID:"

	    if  [ -z  "$FNUM" ]; then
				clear
				print "Please input the LPAR_ID."
				read ANSWER?"Please input the Enter to Continue." 
				main
		fi

		if [ $FNUM == Q ] || [  $FNUM == q ]; then
				./HMC_menu.sh;exit
#				clear
#				print "You exit the shell."
#				read ANSWER?"Please input the Enter to go to the Menu." 
		fi

		if	[ ${FNUM##*[!0-9]*} ]; then
				FNUM=$FNUM
		else
				clear
				print "Please input the Number for LPAR_ID" 
				read ANSWER?"Please input the Enter to Continue." 
				main
		fi
#set Last LPAR_ID
read LNUM?"Please input the you want to active Last LPAR_ID:"

	    if  [ -z  "$LNUM" ]; then
				clear
				print "Please input the LPAR_ID."
				read ANSWER?"Please input the Enter to Continue." 
				main
		fi
		if [ $LNUM == Q ] || [  $LNUM == q ]; then
				./HMC_menu.sh;exit
#				clear
#				print "You exit the shell."
#				read ANSWER?"Please input the Enter to go to the Menu." 
		fi
		if	[ ${LNUM##*[!0-9]*} ]; then
				LNUM=$LNUM
		else
				clear
				print "Please input the Number for LPAR_ID" 
				read ANSWER?"Please input the Enter to Continue." 
				main
		fi

		if [ $LNUM -lt $FNUM ];then
			clear
			echo "You First LPAR_ID bigger than last LPAR_ID.Please to check"
			read ANSWER?"Please input the Enter to Continue." 
			main
		fi

		if [ $LNUM -gt $TOTLE ];then
			clear
			echo "You Last LPAR_ID bigger than Totle LPAR_ID,Please to check"
			read ANSWER?"Please input the Enter to Continue." 
			main
		fi

		clear
		print "You want to active first lpar_id : $FNUM "
		print "You want to active last lpar_id  : $LNUM "
		read ANSWER?"Please to type YES to do next or NO to quit:"
		case $ANSWER in
		 no|n)
				main
				;;
		yes|y)
				To_ssh
				;;
			*)
				echo "You input ther error,please input the yes or no."
				read ANSWER?"Please input the enter to restart."
				main
			;;

		esac
}
#scp FNUM.txt LNUM.txt to /home/hscroot/
#To active start FNUM.txt range to LNUM.txt.
To_ssh () {
		
		echo $FNUM > FNUM.txt
		echo $LNUM > LNUM.txt
#scp FNUM.txt LNUM.txt hscroot@${HMC}:~/
		scp FNUM.txt LNUM.txt hscroot@${HMC}:~/
		clear
		STATE=$?
	 	if [[ $STATE -ne 0 ]]; then
		 	echo "To SCP File:FNUM.txt && LNUM.txt to $HMC Fail."
		 	exit 1
	    fi

		ssh hscroot@${HMC}  <  active_lpar_rcmd.sh 
#		ssh bruce@${HMC}  <  active_lpar_rcmd.sh 
		STATE=$?
	 	if [[ $STATE -eq 0 ]]; then
		 	echo "Use ssh command to control $HMC Success."
		 	exit 0
	 	else
		 	echo "Use ssh command to control $HMC Fail."
		 	exit 1
	    fi
}

main

