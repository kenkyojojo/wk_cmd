#!/usr/bin/ksh

#開啟各個LAPR，經由LPAR_ID 由小至大依序開啟,以每10秒開啟10台LPAR，從LPAR_ID 2號開始開啟。
#因LPAR_ID為1時為VIOS1，而VIOS1因前項操作已先開啟。

for SYSTEM in `lssyscfg -r sys -F name `
do
		for LPARID in `lssyscfg -m $SYSTEM -r lpar -F lpar_id | sort -n| grep -v '^1$'|grep -v '^2$'`
        do
				count=$(($count+1))
				if [[ $count -eq 10 ]];
				then
					 sleep 10;
					 count=0
				fi

				if [[ LPARID -ge "3"  &&  LPARID -le "96" ]] ; then
					echo "To Start Active LPAR_ID:${LPARID}"
					chsysstate -m $SYSTEM -o on -r lpar --id ${LPARID}  -f FIX_FAST
					echo "To Start Active LPAR_ID:${LPARID} done"
				else
					echo "Please to Check LPAR ID"
					exit 1
				fi
        done
done
