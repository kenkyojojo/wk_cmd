#!/usr/bin/ksh
IOS=/usr/ios/cli/ioscli
#ent 34  VLAN2
$IOS mkvdev -lnagg ent16 ent17 ent18 -attr mode=8023ad
#ent 35 VLAN12
$IOS mkvdev -lnagg ent12 ent13 ent14 -attr mode=8023ad
#ent 36  VLAN4
$IOS mkvdev -lnagg ent8 ent9 -attr mode=8023ad
#ent 37 VLAN5
$IOS mkvdev -lnagg ent10 ent11 -attr mode=8023ad
#ent 38 VLAN101
$IOS mkvdev -lnagg ent4 ent5 -attr mode=8023ad
#ent 39 VLAN111
$IOS mkvdev -lnagg ent6 ent7 -attr mode=8023ad
