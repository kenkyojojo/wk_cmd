#!/bin/bash


select_def () {
#select use the PS3 to prompt
PS3="Pick an animal:"
select animal in cow pig dog quit
do
#do not user the REPLY variable can't type the match words, just only type 1 2 3 4.
	case $animal in

	cow) 
		echo "Moo"
		;;
	pig) 
		echo "Oink"
		;;
	dog) 
		echo "woof"
		;;
	quit)
		exit
		;;
	'') 
		echo "Not in the barn"
		;;
	esac
done
}

select_REPLY () {

#select use the PS3 to prompt
PS3="Pick an animal:"
select animal in cow pig dog quit
do
#use the REPLY variable can type the match words
	case $REPLY in

	1|cow|COW) 
		echo "Moo"
		;;
	2|pig|PIG) 
		echo "Oink"
		;;
	3|dog|DOG) 
		echo "woof"
		;;
	4|quit|QUIT)
		exit
		;;
	'') 
		echo "Not in the barn"
		;;
	esac
done
}

#select_REPLY
select_def
