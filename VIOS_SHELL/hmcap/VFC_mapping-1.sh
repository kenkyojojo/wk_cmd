#!/usr/bin/ksh 
IOS=/usr/ios/cli/ioscli

#VIOS1
#MDS1 >> vfchost0
$IOS vfcmap -vadapter vfchost0 -fcp fcs2
#MDS2 >> vfchost1
$IOS vfcmap -vadapter vfchost1 -fcp fcs0
#LOG1 >> vfchost2
$IOS vfcmap -vadapter vfchost2 -fcp fcs2
#LOG2 >> vfchost3
$IOS vfcmap -vadapter vfchost3 -fcp fcs0
#DAR1-1 >> vfchost4
$IOS vfcmap -vadapter vfchost4 -fcp fcs2
#DAR2-1 >> vfchost5
$IOS vfcmap -vadapter vfchost5 -fcp fcs0
#DAP1-1 >> vfchost6
$IOS vfcmap -vadapter vfchost6 -fcp fcs2
#DAP2-1 >> vfchost7
$IOS vfcmap -vadapter vfchost7 -fcp fcs0
#NIM >> vfchost7
$IOS vfcmap -vadapter vfchost8 -fcp fcs2
#WK >> vfchost7
$IOS vfcmap -vadapter vfchost9 -fcp fcs2

