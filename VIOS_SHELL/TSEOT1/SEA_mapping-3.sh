#!/usr/bin/ksh
IOS=/usr/ios/cli/ioscli
#### mapping Vlan:101 Physical:ent0  VEA:ent8   Ctl_chan:ent16 to SEA:ent24 ####
$IOS mkvdev -sea ent0 -vadapter ent8 -default ent8 -defaultid 101 -attr ha_mode=auto ctl_chan=ent16

#### mapping Vlan:102 Physical:ent1  VEA:ent9   Ctl_chan:ent17 to SEA:ent25 ####
$IOS mkvdev -sea ent1 -vadapter ent9 -default ent9 -defaultid 102 -attr ha_mode=auto ctl_chan=ent17

#### mapping Vlan:112 Physical:ent2  VEA:ent10  Ctl_chan:ent18 to SEA:ent26 ####
$IOS mkvdev -sea ent2 -vadapter ent10 -default ent10 -defaultid 112 -attr ha_mode=auto ctl_chan=ent18

#### mapping Vlan:2   Physical:ent3  VEA:ent11  Ctl_chan:ent19 to SEA:ent27 ####
$IOS mkvdev -sea ent3 -vadapter ent11 -default ent11 -defaultid 2 -attr ha_mode=auto ctl_chan=ent19

#### mapping Vlan:21  Physical:ent4  VEA:ent12  Ctl_chan:ent20 to SEA:ent28 ####
$IOS mkvdev -sea ent4 -vadapter ent12 -default ent12 -defaultid 21 -attr ha_mode=auto ctl_chan=ent20

#### mapping Vlan:4   Physical:ent5  VEA:ent13  Ctl_chan:ent21 to SEA:ent29 ####
$IOS mkvdev -sea ent5 -vadapter ent13 -default ent13 -defaultid 4 -attr ha_mode=auto ctl_chan=ent21

#### mapping Vlan:5   Physical:ent6  VEA:ent14  Ctl_chan:ent22 to SEA:ent30 ####
$IOS mkvdev -sea ent6 -vadapter ent14 -default ent14 -defaultid 5 -attr ha_mode=auto ctl_chan=ent22

#### mapping Vlan:121 Physical:ent7  VEA:ent15  Ctl_chan:ent23 to SEA:ent31 ####
$IOS mkvdev -sea ent7 -vadapter ent15 -default ent15 -defaultid 121 -attr ha_mode=auto ctl_chan=ent23

