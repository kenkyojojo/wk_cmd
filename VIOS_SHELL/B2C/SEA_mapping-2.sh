#!/usr/bin/ksh
IOS=/usr/ios/cli/ioscli
mkvdev -sea ent0 -vadapter ent8 -default ent8 -defaultid 3 -attr ha_mode=auto ctl_chan=ent12
mkvdev -sea ent1 -vadapter ent9 -default ent9 -defaultid 4 -attr ha_mode=auto ctl_chan=ent13
mkvdev -sea ent2 -vadapter ent10 -default ent10 -defaultid 5 -attr ha_mode=auto ctl_chan=ent14
mkvdev -sea ent3 -vadapter ent11 -default ent11 -defaultid 6 -attr ha_mode=auto ctl_chan=ent15
