#! /bin/bash

# 把一個大於或等於2以上的正整數，分解成質因數的連乘積。

shopt -s -o nounset

declare -i Num
declare -i i
declare -i cnt

while [[ $Num -lt 2 ]]
do
    read -p "請輸入一個 2 以上的正整數: " Num
done

i=2

echo -n $Num '= '
while ((Num>=i))
do
	cnt=0
	tmp=Num%i
	while [[ $tmp -eq 0 ]]
	do
		((Num/=i))
		((cnt++))
		tmp=Num%i
	done
	
	if [[ $cnt -gt 0 ]]; then
		echo -n $i 
		[ $cnt  -gt 1 ] && echo -n '^'$cnt
        [ $Num -gt 1 ] && echo -n ' * '
	fi
	
	((i>=3 ? i+=2 : i++))
done
echo 

