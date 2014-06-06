#!/usr/bin/ksh

for SYSTEM in `lssyscfg -r sys -F name `
do
		for ID in `lssyscfg -m $SYSTEM -r lpar -F lpar_id | sort -n| grep -v '^1$|^2$'`
        do
					chsysstate -m $SYSTEM -o shutdown -r lpar -id ${ID}  --restart
					echo "To restart LPAR_ID:${ID} done" 
        done
done
