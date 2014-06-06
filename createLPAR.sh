#!/bin/bash

#. lpar.conf

# ----- Client LPAR default values -----
#CLIENT_NAME="linux_test"         # Name of the partition
#CLIENT_NAME=(linux_test bruce_test qqqqq)     # Name of the partition
#CLIENT_PROFIL="client_default":  # Name of the profile
#CLIENT_PROFIL="$CLIENT_NAME"  # Name of the profile
#CLIENT_ENV="aixlinux"           # Operating environment
#CLIENT_MINMEM="512"             # Minimum memory in megabyte
#CLIENT_DESMEM="512"             # Desired memory in megabyte
#CLIENT_MAXMEM="512"             # Maximum memory in megabyte
#CLIENT_PMODE="shared"           # shared or ded
#CLIENT_SMODE="uncap"            # cap or uncap
#CLIENT_SWEIGHT="128"            # Value between 0 and 255
#CLIENT_MINPU="0.1"              # Min processing units
#CLIENT_DESPU="0.4"              # Des processing units
#CLIENT_MAXPU="2.0"              # Max processing units
#CLIENT_MINVP="1"                # Min virtual CPU
#CLIENT_DESVP="2"                # Des virtual CPU
#CLIENT_MAXVP="4"                # Max virtual CPU
#CLIENT_VSLOT="10"               # Number of virtual slots
#CLIENT_VETH="2/1/1//0/1"        # Virtual Ethernet adapter
#CLIENT_VSCSI="3/client/1//4/1"  # Virtual SCSI client adapter
#CLIENT_START="0"                # Start with manages system or not
#CLIENT_BOOT="norm"              # Boot mode = normal
#CLIENT_PWR="none"               # Power controlling partition
#CLIENT_CON="0"                  # Connection monitoring
#CLIENT_IOPOOL="none"            # IOPOOL

 [ -z $1  ] && echo "you need to put the config file" && exit 0


cat /dev/null > test.cfg

. $1
echo  "Creating LPAR..." >> $0.log
for CLIENT_NAME in "${CLIENT_NAME[@]}"
do

echo  "Start to Config $CLIENT_NAME." >> $0.log 
echo "name=$CLIENT_NAME,\
profile_name=$CLIENT_NAME,lpar_env=$CLIENT_ENV,min_mem=$CLIENT_MINMEM,\
desired_mem=$CLIENT_DESMEM,max_mem=$CLIENT_MAXMEM,proc_mode=$CLIENT_PMODE,\
sharing_mode=$CLIENT_SMODE,min_proc_units=$CLIENT_MINPU,\
desired_proc_units=$CLIENT_DESPU,max_proc_units=$CLIENT_MAXPU,\
min_procs=$CLIENT_MINVP,desired_procs=$CLIENT_DESVP,max_procs=$CLIENT_MAXVP,\
uncap_weight=$CLIENT_SWEIGHT,lpar_io_pool_ids=$CLIENT_IOPOOL,\
max_virtual_slots=$CLIENT_VSLOT,auto_start=$CLIENT_START,\
boot_mode=$CLIENT_BOOT,power_ctrl_lpar_ids=$CLIENT_PWR,\
conn_monitoring=$CLIENT_CON,max_virtual_slots=$CLIENT_VSLOT,\
virtual_eth_adapters=$CLIENT_VETH,virtual_scsi_adapters=$CLIENT_VSCSI" >> test.cfg
echo  "Finish $CLIENT_NAME Config" >> $0.log 
done
