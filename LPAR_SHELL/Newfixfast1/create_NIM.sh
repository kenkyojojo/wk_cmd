#!/bin/ksh

CLIENT_NAME="NIM_Server"    # Name of the partition --menual
CLIENT_PROFILE="FIX_FAST" # Name of the profile --menual
CVIOS1="VIOS1-1"                # Name of the VIOS1   --menual 
CVIOS2="VIOS1-2"                # Name of the VIOS2   --menual
CLIENT_ENV="aixlinux"           # Operating environment
CLIENT_MINMEM="8192"             # Minimum memory in megabyte
CLIENT_DESMEM="12288"             # Desired memory in megabyte
CLIENT_MAXMEM="24576"             # Maximum memory in megabyte
CLIENT_PMODE="shared"           # shared or ded
CLIENT_SMODE="uncap"            # cap or uncap
CLIENT_SWEIGHT="128"            # Value between 0 and 255
CLIENT_MINPU="0.3"              # Min processing units
CLIENT_DESPU="0.6"              # Des processing units
CLIENT_MAXPU="2.0"              # Max processing units
CLIENT_MINVP="1"                # Min virtual CPU
CLIENT_DESVP="1"                # Des virtual CPU
CLIENT_MAXVP="2"                # Max virtual CPU
CLIENT_VSLOT="200"               # Number of virtual slots
CLIENT_VETH="2/0/4//0/0,3/0/5//0/0"       # Virtual Ethernet adapter
#CLIENT_VSCSI="3/client//VIOS1/3/1"  # Virtual SCSI client adapter. 
#CLIENT_VFC="4/client//VIOS1/4//1"  # Virtual FC client adapter
CLIENT_START="0"                # Start with manages system or not
CLIENT_BOOT="norm"              # Boot mode = normal
CLIENT_PWR="none"               # Power controlling partition
CLIENT_CON="0"                  # Connection monitoring
CLIENT_IOPOOL="none"            # IOPOOL
CSLOT_NUM="./vios_slot_num.txt"

config_profile () {
    print "$1" >> lpar_profile.cfg 
}


config_lpar_name () {
#read  CLIENT_NAME?"請輸入 LPAR name:" 
#[ -z "$CLIENT_NAME" ]  && print "LPAR is empty"  && exit 0

typeset -i Limnum Nnum
Limnum=0
Nnum=0
while [ $Number != $Limnum ] ;do
	
	(( Nnum = $Nnum + 1 ))
	config_lpar_name="$CLIENT_NAME"

#config_scsi "$config_lpar_name"
	 config_fc "$config_lpar_name"
	(( Number = ${Number} - 1 )) 	#print "$default,$server_slot " 
done
}

config_scsi() {

# CLIENT_VSCSI="3/client//VIOS1/3/1"
typeset -i server_slot client_slot_v1 client_slot_v2
default=3
client_slot_v1=$default
client_slot_v2="$client_slot_v1 + 1"
server_slot=`cat $CSLOT_NUM`

CLIENT_VSCSI="$client_slot_v1/client//$CVIOS1/$server_slot/1,$client_slot_v2/client//$CVIOS2/$server_slot/1"

	 echo "$server_slot/server//$config_lpar_name/$client_slot_v1/1" >> ./slot_num_2_scsi_vios1.txt
	 echo "$server_slot/server//$config_lpar_name/$client_slot_v2/1" >> ./slot_num_2_scsi_vios2.txt


	(( server_slot = `cat $CSLOT_NUM` + 1 ))
	echo $server_slot > $CSLOT_NUM

	 config_scsi=$CLIENT_VSCSI
	 config_fc "$config_scsi"

}

config_fc() {

#CLIENT_VFC="4/client//VIOS1/4//1"  # Virtual FC client adapter

typeset -i server_slot client_slot_v1 client_slot_v2

(( default = ${client_slot_v2} + 1 ))
#client_slot_v1=$default
client_slot_v1=4
client_slot_v2="$client_slot_v1 + 1"
server_slot=`cat $CSLOT_NUM`

CLIENT_VFC="$client_slot_v1/client//$CVIOS1/$server_slot//1,$client_slot_v2/client//$CVIOS2/$server_slot//1"

	
	 echo "$server_slot/server//$config_lpar_name/$client_slot_v1//1"   >> ./slot_num_2_fc_vios1.txt
	 echo "$server_slot/server//$config_lpar_name/$client_slot_v2//1"   >> ./slot_num_2_fc_vios2.txt

	(( server_slot = `cat $CSLOT_NUM` + 1 ))
	 echo $server_slot > $CSLOT_NUM

	 config_fc=$CLIENT_VFC

	 combind "$config_fc"

}


config_lpar_number () {
#cat /dev/null > lpar.cfg
#clear ""
#print "You can type x or X exit the shell" 
#read Number?"請輸入LPAR數量:" 
#read Number?"How many Lpars do you want to creat, please enter the number:" 
#if   [ -z  $Number ]; then
#	print "The default Numbers is one" ; Number=1
#elif [ ${Number##*[!0-9]*} ] ; then
#	Number=$Number
#elif [ $Number = "X" ] ; then
#	print "you exit the shell."; exit 1
#elif [ $Number = "x" ] ; then
#	print "you exit the shell."; exit 1
#else
#	print "please enter the number."; clear ""
#	lpar_number
#fi
Number=1
lpar_number="$Number"
config_lpar_name "$lpar_number"
}

#combind () {
#	config=""name=$config_lpar_name","profile_name=$CLIENT_PROFILE","lpar_env=$CLIENT_ENV","min_mem=$CLIENT_MINMEM",\
#"desired_mem=$CLIENT_DESMEM","max_mem=$CLIENT_MAXMEM","proc_mode=$CLIENT_PMODE","sharing_mode=$CLIENT_SMODE",\
#"uncap_weight=$CLIENT_SWEIGHT","min_proc_units=$CLIENT_MINPU","desired_proc_units=$CLIENT_DESPU","max_proc_units=$CLIENT_MAXPU",\
#"min_procs=$CLIENT_MINVP","desired_procs=$CLIENT_DESVP","max_procs=$CLIENT_MAXVP","max_virtual_slots=$CLIENT_VSLOT",\
#"\"virtual_eth_adapters=$CLIENT_VETH\",\"virtual_scsi_adapters=$config_scsi\","\"virtual_fc_adapters=$config_fc\",\
#"auto_start=$CLIENT_START","boot_mode=$CLIENT_BOOT","power_ctrl_lpar_ids=$CLIENT_PWR","conn_monitoring=$CLIENT_CON",\
#"lpar_io_pool_ids=$CLIENT_IOPOOL""
#
#	config_profile $config
#}

combind () {
	config=""name=$config_lpar_name","profile_name=$CLIENT_PROFILE","lpar_env=$CLIENT_ENV","min_mem=$CLIENT_MINMEM",\
"desired_mem=$CLIENT_DESMEM","max_mem=$CLIENT_MAXMEM","proc_mode=$CLIENT_PMODE","sharing_mode=$CLIENT_SMODE",\
"uncap_weight=$CLIENT_SWEIGHT","min_proc_units=$CLIENT_MINPU","desired_proc_units=$CLIENT_DESPU","max_proc_units=$CLIENT_MAXPU",\
"min_procs=$CLIENT_MINVP","desired_procs=$CLIENT_DESVP","max_procs=$CLIENT_MAXVP","max_virtual_slots=$CLIENT_VSLOT",\
"\"virtual_eth_adapters=$CLIENT_VETH\","\"virtual_fc_adapters=$config_fc\","auto_start=$CLIENT_START",\
"boot_mode=$CLIENT_BOOT","power_ctrl_lpar_ids=$CLIENT_PWR","conn_monitoring=$CLIENT_CON",\
"lpar_io_pool_ids=$CLIENT_IOPOOL""

	config_profile $config
}

config_lpar_number
#config_vios_profile
#./create_vios.sh
