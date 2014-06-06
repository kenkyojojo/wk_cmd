#!/bin/ksh
#. ./slot_num_2_scsi_vios1.txt
#. ./slot_num_2_fc_vios1.txt
#CLIENT_NAME="VIOS1 VIOS2"    # Name of the partition --menual
CLIENT_NAME="VIOS66 VIOS77"    # Name of the partition --menual
CLIENT_PROFILE="client_default" # Name of the profile --menual
CLIENT_ENV="vioserver"           # Operating environment
CLIENT_MINMEM="512"             # Minimum memory in megabyte
CLIENT_DESMEM="512"             # Desired memory in megabyte
CLIENT_MAXMEM="512"             # Maximum memory in megabyte
CLIENT_PMODE="shared"           # shared or ded
CLIENT_SMODE="uncap"            # cap or uncap
CLIENT_SWEIGHT="128"            # Value between 0 and 255
CLIENT_MINPU="0.1"              # Min processing units
CLIENT_DESPU="0.4"              # Des processing units
CLIENT_MAXPU="2.0"              # Max processing units
CLIENT_MINVP="1"                # Min virtual CPU
CLIENT_DESVP="2"                # Des virtual CPU
CLIENT_MAXVP="4"                # Max virtual CPU
CLIENT_VSLOT="100"               # Number of virtual slots
CLIENT_VETH="2/0/1//0/1"       # Virtual Ethernet adapter
#CLIENT_VSCSI="3/client/1/VIOS1/4/1"  # Virtual SCSI client adapter
CLIENT_VSCSI="$SCSI"  # Virtual SCSI client adapter
CLIENT_VFC="$FC"  # Virtual FC client adapter
CLIENT_START="0"                # Start with manages system or not
CLIENT_BOOT="norm"              # Boot mode = normal
CLIENT_PWR="none"               # Power controlling partition
CLIENT_CON="0"                  # Connection monitoring
CLIENT_IOPOOL="none"            # IOPOOL

cat /dev/null > vio.cfg
profile () {
    print "$1" >> vio.cfg
}

profile_no_vdev () {
    print "$1" >> vio_no_vdev.cfg
}


combind () {
	config=""name=$CLIENT_NAME","profile_name=$CLIENT_PROFILE","lpar_env=$CLIENT_ENV","min_mem=$CLIENT_MINMEM",\
"desired_mem=$CLIENT_DESMEM","max_mem=$CLIENT_MAXMEM","proc_mode=$CLIENT_PMODE","sharing_mode=$CLIENT_SMODE",\
"uncap_weight=$CLIENT_SWEIGHT","min_proc_units=$CLIENT_MINPU","desired_proc_units=$CLIENT_DESPU",\
"max_proc_units=$CLIENT_MAXPU","min_procs=$CLIENT_MINVP","desired_procs=$CLIENT_DESVP",\
"max_procs=$CLIENT_MAXVP","max_virtual_slots=$CLIENT_VSLOT",\"virtual_eth_adapters=$CLIENT_VETH\",\
\"virtual_scsi_adapters=$CLIENT_VSCSI\",\"virtual_fc_adapters=$CLIENT_VFC\","auto_start=$CLIENT_START",\
"boot_mode=$CLIENT_BOOT","power_ctrl_lpar_ids=$CLIENT_PWR","conn_monitoring=$CLIENT_CON",\
"lpar_io_pool_ids=$CLIENT_IOPOOL""

	profile $config
}

combind_no_virtual_dev () {
	config=""name=$CLIENT_NAME","profile_name=$CLIENT_PROFILE","lpar_env=$CLIENT_ENV","min_mem=$CLIENT_MINMEM",\
"desired_mem=$CLIENT_DESMEM","max_mem=$CLIENT_MAXMEM","proc_mode=$CLIENT_PMODE","sharing_mode=$CLIENT_SMODE",\
"uncap_weight=$CLIENT_SWEIGHT","min_proc_units=$CLIENT_MINPU","desired_proc_units=$CLIENT_DESPU",\
"max_proc_units=$CLIENT_MAXPU","min_procs=$CLIENT_MINVP","desired_procs=$CLIENT_DESVP",\
"max_procs=$CLIENT_MAXVP","max_virtual_slots=$CLIENT_VSLOT",\"virtual_eth_adapters=$CLIENT_VETH\",\
"auto_start=$CLIENT_START","boot_mode=$CLIENT_BOOT","power_ctrl_lpar_ids=$CLIENT_PWR","conn_monitoring=$CLIENT_CON",\
"lpar_io_pool_ids=$CLIENT_IOPOOL""

	profile_no_vdev $config
}

config_vios_profile () {

	for FF in `ls   *fc*vios?.txt`
	do
		for DD in $FF
		do
			cat $DD | sed -e '1 s/^/SCSI=\"/' |  sed -e 's/$/,\\/' |sed '$ s/\,\\/"/' >> bruce.txt
			mv bruce.txt $FF
		done
	done

	for FF in `ls  *scsi*vios?.txt`
	do
		for DD in $FF
		do
			cat $DD | sed -e '1 s/^/SCSI=\"/' |  sed -e 's/$/,\\/' |sed '$ s/\,\\/"/' >> bruce.txt
			mv bruce.txt $FF
		done

	done


}

config_name () {
for name in $CLIENT_NAME
do
    CLIENT_NAME=$name
    if [ $name = VIOS66 ]; then
	. ./slot_num_2_scsi_vios1.txt
	. ./slot_num_2_fc_vios1.txt
	CLIENT_VSCSI="$SCSI"  # Virtual SCSI client adapter
	CLIENT_VFC="$FC"  # Virtual FC client adapter
    else 
	. ./slot_num_2_scsi_vios2.txt
	. ./slot_num_2_fc_vios2.txt
	CLIENT_VSCSI="$SCSI"  # Virtual SCSI client adapter
	CLIENT_VFC="$FC"  # Virtual FC client adapter
    fi
    combind
    combind_no_virtual_dev
done
}

config_vios_profile
config_name

rm -f ./slot_num_2*.txt 

