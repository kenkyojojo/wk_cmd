#!/usr/bin/ksh
IOS=/usr/ios/cli/ioscli
#### mapping Vlan:121 Physical:ent4,ent7 to eth_chan:ent24 ####
$IOS mkvdev -lnagg ent4 ent7 -attr mode=8023ad
