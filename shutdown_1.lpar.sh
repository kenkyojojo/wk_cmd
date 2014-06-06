#!/usr/bin/ksh
#關閉各個LAPR，經由LPAR_ID 由大至小依序關閉,以一次性關閉所有LPAR,直至VIOS以每秒一台VIOS。

for SYSTEM in `lssyscfg -r sys -F name | grep 9179`
do
		for LPARID in `lssyscfg -m $SYSTEM -r lpar -F lpar_id | sort -rn`
        do
			
		    if [[ $LPARID -eq "1" || $LPARID -eq "2" ]]; then
				 echo "VIOS don't shutdown."
			else
			     echo "To Start Shutdown LPAR_ID:${LPARID}"

				 chsysstate -m $SYSTEM -r lpar --id $LPARID -o shutdown --immed 

			     echo "To Start Shutdown LPAR_ID:${LPARID} done"
			fi
        done
done


