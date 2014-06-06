#!/usr/bin/ksh
rm *.txt
main () {
clear ""
print "	<< FIX/FAST LPAR Active && Shutdown Menu >>"
print "1. Active LPAR "
print ""
print "2. Shutdown LPAR"
print ""
print "You can type q or Q exit the shell"
read Menu_No?"Please to choose(1-2):"
case $Menu_No in
	1)
		./active_lpar.Menu.sh	
		;;
	2)
		./shutdown_lpar.Menu.sh
		;;
	q|Q)
		exit 
		;;

	*)
		clear
		print "You input ther error,please input the (1-2) option"
		read $Menu_No?"Please input the enter to restart."
		main
		;;

esac
}
main
