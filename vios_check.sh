#!/bin/ksh

# ================================================================== #
#Link Status為實體線路狀態，up代表有接線，down代表沒接線
#重要 State代表這個port的狀態，狀態有PRIMARY、BACKUP(代表有SEA failover)、LIMBO(若有綁定etherchannel，但是switch上沒綁，即使有接線也會是LIMBO狀態
# ================================================================== #
#
#
echo ==================================================================
for SEA in `lsdev | grep ent | grep Shared | awk '{print $1}'`
do
	######print VLAN ID and real_adapter######
	echo "SEA $SEA"
	lsattr -El $SEA | egrep "pvid |real_adapter" | awk '{print $1,$2}'
	#######print physcial location######
	lscfg | grep -w `lsattr -El $SEA | grep real_adapter | awk '{print $2}'` | awk '{print $3}'
	#######check etherchannel#######
	lscfg | grep -w `lsattr -El $SEA | grep real_adapter | awk '{print $2}'` > /dev/null
	######print etherchannel#######
	if [ $? != 0 ] ; then
		echo "etherchannel \c"
		temp=$(lsattr -El `lsattr -El $SEA | grep real_adapter | awk '{print $2}'` | grep 'adapter_names' | awk '{print $2}')
		echo $temp
	######print ehterchannel physical location######
		lscfg | grep -w `echo $temp | cut -d ',' -f 1` | awk '{print $3}'
		lscfg | grep -w `echo $temp | cut -d ',' -f 2` | awk '{print $3}'
	fi
	######print link status######
	entstat -d $SEA >/tmp/entstat 2> /dev/null
	egrep "Link Status|State|Duplex" /tmp/entstat | egrep -iv "lan|actor|partner"
	echo ==================================================================
	rm /tmp/entstat
done
