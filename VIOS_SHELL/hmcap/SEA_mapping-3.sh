#!/usr/bin/ksh
IOS=/usr/ios/cli/ioscli
####mapping vlan2 SEA ent22 ####
$IOS mkvdev -sea ent4 -vadapter ent8 -default ent8 -defaultid 2 -attr ha_mode=auto ctl_chan=ent14

####mapping vlan4 SEA ent23 ####
$IOS mkvdev -sea ent5 -vadapter ent9 -default ent9 -defaultid 4 -attr ha_mode=auto ctl_chan=ent15

####mapping vlan5 SEA ent24 ####
$IOS mkvdev -sea ent6 -vadapter ent10 -default ent10 -defaultid 5 -attr ha_mode=auto ctl_chan=ent16

####mapping vlan6 SEA ent25 ####
$IOS mkvdev -sea ent7 -vadapter ent11 -default ent11 -defaultid 6 -attr ha_mode=auto ctl_chan=ent17

####mapping vlan101 SEA ent26####
$IOS mkvdev -sea ent20 -vadapter ent12 -default ent12 -defaultid 101 -attr ha_mode=auto ctl_chan=ent18

####mapping vlan111 SEA ent27 ####
$IOS mkvdev -sea ent21 -vadapter ent13 -default ent13 -defaultid 111 -attr ha_mode=auto ctl_chan=ent19
