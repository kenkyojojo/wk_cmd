#!/bin/ksh

#CLIENT_NAME=(linux_test bruce_test)     # Name of the partition --menual
CLIENT_PROFILE="client_default" # Name of the profile --menual
CLIENT_ENV="aixlinux"           # Operating environment
CLIENT_MINMEM="512"             # Minimum memory in megabyte
CLIENT_DESMEM="2048"             # Desired memory in megabyte
CLIENT_MAXMEM="4096"             # Maximum memory in megabyte
CLIENT_PMODE="shared"           # shared or ded
CLIENT_SMODE="cap"            # cap or uncap
CLIENT_SWEIGHT="128"            # Value between 0 and 255
CLIENT_MINPU="0.1"              # Min processing units
CLIENT_DESPU="0.4"              # Des processing units
CLIENT_MAXPU="1.0"              # Max processing units
CLIENT_MINVP="1"                # Min virtual CPU
CLIENT_DESVP="2"                # Des virtual CPU
CLIENT_MAXVP="4"                # Max virtual CPU
CLIENT_VSLOT="500"               # Number of virtual slots
CLIENT_VETH="2/0/4//0/0"       # Virtual Ethernet adapter
CLIENT_VSCSI="3/client/66/VIO66/3/1"  # Virtual SCSI client adapter
CLIENT_START="0"                # Start with manages system or not
CLIENT_BOOT="norm"              # Boot mode = normal
CLIENT_PWR="none"               # Power controlling partition
CLIENT_CON="0"                  # Connection monitoring
CLIENT_IOPOOL="none"            # IOPOOL

profile () {
    print "$1" >> lpar.log 
}

config_Lpar_name () {
read  CLIENT_NAME?"請輸入 LPAR name:" 
[ -z "$CLIENT_NAME" ]  && print "LPAR is empty"  && exit 0

typeset -i Limnum
Limnum=0
while [ $Number != $Limnum ] ;do

	config_Lpar_name="$CLIENT_NAME${Number}"

# config_profile "$config_Lpar_name"
	 combind "$config_Lpar_name"

	((Number= ${Number} - 1))

done
}

#config_profile () {
#	config_profile="$config_Lpar_name"
#	combind "$config_profile"
#}

#config_Lpar_name () {
#read  CLIENT_NAME?"請輸入 LPAR name:" 
#[ -z "$CLIENT_NAME" ]  && print "LPAR is empty"  && exit 0
#cat /dev/null > lpar.log
#
#typeset -i Limnum
#Limnum=0
#while [ $Number != $Limnum ] ;do
#
#	Config="CLIENT_NAME=$CLIENT_NAME${Number},CLIENT_PROFIL="client_default",CLIENT_ENV="aixlinux",CLIENT_MINMEM="512",CLIENT_DESMEM="512",\
#CLIENT_MAXMEM="512",CLIENT_PMODE="shared",CLIENT_SMODE="uncap",CLIENT_SWEIGHT="128",CLIENT_MINPU="0.1",CLIENT_DESPU="0.4",CLIENT_MAXPU="2.0",\
#CLIENT_MINVP="1",CLIENT_DESVP="2",CLIENT_MAXVP="4",CLIENT_VSLOT="10",CLIENT_VETH="2/1/1//0/1",CLIENT_VSCSI="3/client/1//4/1",CLIENT_START="0",\
#CLIENT_BOOT="norm",CLIENT_PWR="none",CLIENT_CON="0",CLIENT_IOPOOL="none""
#
#	profile $Config
#	(( Number=${Number} - 1 ))
##
##profile CLIENT_NAME=$CLIENT_NAME${Number} CLIENT_PROFIL="client_default" CLIENT_ENV="aixlinux" CLIENT_MINMEM="512" CLIENT_DESMEM="512"\
##CLIENT_MAXMEM="512" CLIENT_PMODE="shared" CLIENT_SMODE="uncap"
#
#
#done
#}

lpar_number () {
cat /dev/null > lpar.log
clear ""
print "You can enter x or X exit the shell" 
read Number?"How many Lpars do you want to creat, please type the number:" 
if   [ -z  $Number ]; then
	print "The default Numbers is one" ; Number=1
elif [ ${Number##*[!0-9]*} ] ; then
	Number=$Number
elif [ $Number = "X" ] ; then
	print "you exit the shell."; exit 1
elif [ $Number = "x" ] ; then
	print "you exit the shell."; exit 1
else
	print "please type the number."; clear ""
	lpar_number
fi
lpar_number="$Number"
config_Lpar_name "$lpar_number"
}

combind () {
	config=""name=$config_Lpar_name","profile_name=$CLIENT_PROFILE","lpar_env=$CLIENT_ENV","min_mem=$CLIENT_MINMEM",\
"desired_mem=$CLIENT_DESMEM","max_mem=$CLIENT_MAXMEM","proc_mode=$CLIENT_PMODE","sharing_mode=$CLIENT_SMODE",\
"uncap_weight=$CLIENT_SWEIGHT","min_proc_units=$CLIENT_MINPU","desired_proc_units=$CLIENT_DESPU","max_proc_units=$CLIENT_MAXPU",\
"min_procs=$CLIENT_MINVP","desired_procs=$CLIENT_DESVP","max_procs=$CLIENT_MAXVP","max_virtual_slots=$CLIENT_VSLOT",\
\"virtual_eth_adapters=$CLIENT_VETH\",\"virtual_scsi_adapters=$CLIENT_VSCSI\","auto_start=$CLIENT_START","boot_mode=$CLIENT_BOOT",\
"power_ctrl_lpar_ids=$CLIENT_PWR","conn_monitoring=$CLIENT_CON","lpar_io_pool_ids=$CLIENT_IOPOOL""
	profile $config

}

lpar_number
