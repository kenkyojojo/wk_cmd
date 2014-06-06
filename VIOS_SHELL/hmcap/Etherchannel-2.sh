#!/usr/bin/ksh
IOS=/usr/ios/cli/ioscli
#ent 20 VLAN101
$IOS mkvdev -lnagg ent0 ent1 -attr mode=8023ad
#ent 21 VLAN111
$IOS mkvdev -lnagg ent2 ent3 -attr mode=8023ad
