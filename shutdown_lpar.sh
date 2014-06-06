#!/usr/bin/ksh
#關閉各個LAPR，經由LPAR_ID 由大至小依序關閉,以一次性關閉所有LPAR,直至VIOS以每秒一台VIOS。

for x in `lssyscfg -r sys -F name `
do
		for i in `lssyscfg -m $x -r lpar -F lpar_id | sort -rn`
        do
			
		    if [[ $i -eq "1" || $i -eq "2" ]]; then
				 sleep 5;
			     echo "To Start Shutdown LPAR_ID:${i}"
				 chsysstate -m $x -r lpar --id $i -o shutdown --immed 
			else
			     echo "To Start Shutdown LPAR_ID:${i}"
				 chsysstate -m $x -r lpar --id $i -o shutdown --immed 
			fi
        done
done


