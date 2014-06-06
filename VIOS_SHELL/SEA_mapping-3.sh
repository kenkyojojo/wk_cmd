#!/usr/bin/ksh
IOS=/usr/ios/cli/ioscli
####mapping vlan2 SEA ent40 ####
$IOS mkvdev -sea ent34 -vadapter ent20 -default ent20 -defaultid 2 -attr ha_mode=auto ctl_chan=ent27

####mapping vlan12 SEA ent41 ####
$IOS mkvdev -sea ent35 -vadapter ent21 -default ent21 -defaultid 12 -attr ha_mode=auto ctl_chan=ent28

####mapping vlan4 SEA ent42 ####
$IOS mkvdev -sea ent36 -vadapter ent22 -default ent22 -defaultid 4 -attr ha_mode=auto ctl_chan=ent29

####mapping vlan5 SEA ent43 ####
$IOS mkvdev -sea ent37 -vadapter ent23 -default ent23 -defaultid 5 -attr ha_mode=auto ctl_chan=ent30

####mapping vlan6 SEA ent44 ####
$IOS mkvdev -sea ent19 -vadapter ent24 -default ent24 -defaultid 6 -attr ha_mode=auto ctl_chan=ent31

####mapping vlan101 SEA ent45####
$IOS mkvdev -sea ent38 -vadapter ent25 -default ent25 -defaultid 101 -attr ha_mode=auto ctl_chan=ent32

####mapping vlan111 SEA ent46 ####
$IOS mkvdev -sea ent39 -vadapter ent26 -default ent26 -defaultid 111 -attr ha_mode=auto ctl_chan=ent33
