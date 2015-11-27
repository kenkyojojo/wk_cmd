#!/usr/bin/ksh
BASE=/tmp/Base.txt
CURR=/tmp/Curr.txt
func_1 () {
while read FILE
do
	$result${FILE}=1
	echo $result${FILE}
	echo ${FILE}
done < $BASE
}

func_2 () {
	echo 1
}

main () {
	time func_1
#	time func_2
}

main
