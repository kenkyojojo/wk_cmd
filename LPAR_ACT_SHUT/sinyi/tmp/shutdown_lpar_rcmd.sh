#!/usr/bin/ksh
FNUM=`cat ./FNUM.txt`
LNUM=`cat ./LNUM.txt`
FDAPIDT=15
FDAPIDE=54
SDAPIDT=55
SDAPIDE=94
TOTLE=96
WAIT=2
LIMT=25
RANGE=$(($LNUM - $FNUM))

#for SYSTEM in `lssyscfg -r sys -F name `
for SYSTEM in ibm
do
#step 1
		if [[ $FNUM -eq $LNUM ]];then
#sleep $WAIT;
			echo "To Start Shutdown LPAR_ID:$FNUM"
			echo "chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM  --immed"
			#chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM --immed 
			STATE=$?
			if [[ $STATE -eq 0 ]];then
				echo "To Start Shutdown LPAR_ID:$FNUM done"
				exit 0
			else 
				echo "To Start Shutdown LPAR_ID:$FNUM Fail"
				exit 1
			fi
		fi


		while [[ $FNUM -le $TOTLE ]];
        do
#step 2
				if [[ $FNUM -lt $FDAPIDT ]]; then 
					while [[ $FNUM -lt $FDAPIDT ]];
					do
#sleep $WAIT;
#echo 2
						echo "To Start Shutdown LPAR_ID:$FNUM"
						echo "chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM  --immed"
						#chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM --immed 
						STATE=$?
						if [[ $STATE -eq 0 ]];then
							echo "To Start Shutdown LPAR_ID:$FNUM done"
							FNUM=$(($FNUM + 1))
						else
							echo "To Start Shutdown LPAR_ID:$FNUM Fail"
							FNUM=$(( $FNUM + 1))
						fi

						if [[ $FNUM -eq $LNUM ]];then
							echo "To Start Shutdown LPAR_ID:$FNUM"
							echo "chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM  --immed"
							#chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM  --immed
							STATE=$?
							if [[ $STATE -eq 0 ]];then
								echo "To Start Shutdown LPAR_ID:$FNUM done"
								exit 0
							else
								echo "To Start Shutdown LPAR_ID:$FNUM Fail"
								exit 1
							fi
						fi
					done

#step 3
				elif [[ $FNUM -eq $FDAPIDT ]] && [[ $LNUM -ge $SDAPIDE ]];then 
					

					while [[ $FNUM -lt $LNUM ]];
					do

#sleep $WAIT;
#echo 3
						if [[ $RANGE -ge $LIMT ]];then
							count=$(( $count + 1 ))
							if [[ $count -eq $LIMT ]];then
							sleep $WAIT;
							count=0
							fi
						fi

						echo "To Start Shutdown LPAR_ID:$FNUM"
						echo "chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM  --immed"
						#chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM  --immed
						STATE=$?
						if [[ $STATE -eq 0 ]];then
							echo "To Start Shutdown LPAR_ID:$FNUM done"
						else
							echo "To Start Shutdown LPAR_ID:$FNUM Fail"
						fi

						SFNUM=$(( $FNUM + 40 ))
						echo "To Start Shutdown LPAR_ID:$SFNUM"
						echo "chsysstate -m $SYSTEM -o osshutdown -r lpar --id $SFNUM  --immed"
						#chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM  --immed
						STATE=$?
						if [[ $STATE -eq 0 ]];then
							echo "To Start Shutdown LPAR_ID:$SFNUM done"
							FNUM=$(( $FNUM + 1))
						else
							echo "To Start Shutdown LPAR_ID:$SFNUM Fail"
							FNUM=$(( $FNUM + 1))
						fi
							
						if [[ $FNUM -eq $SDAPIDT ]] && [[ $SFNUM -lt $LNUM ]] ;then
								FNUM=$(($SFNUM + 1))
								break;
						fi

						if [[ $SFNUM -eq $LNUM ]];then
								exit 
						fi
					done

				else
#step 4
					while [[ $FNUM -ge $FDAPIDT ]] ;
					do
#sleep $WAIT;
#echo 4
						if [[ $RANGE -ge $LIMT ]];then
							count=$(( $count + 1 ))
							if [[ $count -eq $LIMT ]];then
					 		sleep $WAIT;
					 		count=0
							fi
						fi
							if [[ $FNUM -eq $LNUM ]];then
								echo "To Start Shutdown LPAR_ID:$FNUM"
								echo "chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM  --immed"
								#chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM  --immed
								STATE=$?
								if [[ $STATE -eq 0 ]];then
									echo "To Start Shutdown LPAR_ID:$FNUM done"
									exit 0
								else
									echo "To Start Shutdown LPAR_ID:$FNUM Fail"
									exit 1
								fi
							fi

							echo "To Start Shutdown LPAR_ID:$FNUM"
							echo "chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM  --immed"
							#chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM  --immed
							STATE=$?
							if [[ $STATE -eq 0 ]];then
								echo "To Start Shutdown LPAR_ID:$FNUM done"
								FNUM=$(( $FNUM + 1))
							else
								echo "To Start Shutdown LPAR_ID:$FNUM Fail"
								FNUM=$(( $FNUM + 1))
							fi

							if [[ $FNUM -eq $LNUM ]];then
								echo "To Start Shutdown LPAR_ID:$FNUM"
								echo "chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM  --immed"
								#chsysstate -m $SYSTEM -o osshutdown -r lpar --id $FNUM  --immed
								STATE=$?
								if [[ $STATE -eq 0 ]];then
									echo "To Start Shutdown LPAR_ID:$FNUM done"
									exit 0
								else
									echo "To Start Shutdown LPAR_ID:$FNUM Fail"
									FNUM=$(( $FNUM + 1))
								fi
							fi
					done

				fi
        done
done
