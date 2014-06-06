#!/bin/sh

for $MACHINES in `lsnim |grep machines | awk '{print $1}' | grep -vE "VIOS2|master"` 
do 
#clear client config 
nim -Fo  deallocate=all $MACHINES 
nim -o remove '-F' $MACHINES

#reset the machines state
nim -Fo reset $MACHINES

#reset client assign 
# nim -Fo reset $MACHINES

#defind clinet 
#nim -o define -t standalone -a platform=chrp -a netboot_kernel=64 -a cable_type1=tp -a connect=nimsh -a if1="network1 $MACHINES 0" $MACHINES 

#assign clinet 
#nim -o bos_inst -a source=mksysb -a mksysb=DAP -a spot=spotdap -a no_client_boot=yes $MACHINES

#when nim_server error message is 0042-008 
# 
    nim -Fo change -a cpuid=$MACHINES 

	echo "$MACHINE been assigned mksysb" 
done

#check the nim to depoly state
#lsnim -c network

