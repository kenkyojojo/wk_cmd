#!/usr/bin/ksh 
#mapping to fcs2
IOS=/usr/ios/cli/ioscli
$IOS vfcmap -vadapter vfchost0 -fcp fcs2 
$IOS vfcmap -vadapter vfchost2 -fcp fcs2
$IOS vfcmap -vadapter vfchost92 -fcp fcs2 
$IOS vfcmap -vadapter vfchost93 -fcp fcs2 

n=4
while [[ $n -le 7 ]]
do
$IOS vfcmap -vadapter vfchost${n} -fcp fcs2
(( n=$n+1 ))
done

n=12
while [[ $n -le 51 ]]
do
$IOS vfcmap -vadapter vfchost${n} -fcp fcs2
(( n=$n+1 ))
done

###############################################
#mapping to fcs0
$IOS vfcmap -vadapter vfchost1 -fcp fcs0 
$IOS vfcmap -vadapter vfchost3 -fcp fcs0

n=8
while [[ $n -le 11 ]]
do
$IOS vfcmap -vadapter vfchost${n} -fcp fcs0
(( n=$n+1 ))
done

n=52
while [[ $n -le 91 ]]
do
$IOS vfcmap -vadapter vfchost${n} -fcp fcs0
(( n=$n+1 ))
done


