#DAP
for host in `ls -1 *DAP*  | grep -v *DAP1-1.base`;
do 
	echo "######$host######" >> diff_DAP.log
	diff syschk.DAP1-1.base $host | grep -v '^<' |  grep -v '^[1-9]' >> diff_DAP.log 
done

#DAR
for host in `ls -1 *DAR*  | grep -v *DAR1-1.base`;
do 
	echo "######$host######" >> diff_DAR.log
	diff syschk.DAR1-1.base $host | grep -v '^<' |  grep -v '^[1-9]' >> diff_DAR.log 
done

#MDS
for host in `ls -1 *MDS*  | grep -v *MDS1.base`;
do 
	echo "######$host######" >> diff_MDS.log
	diff syschk.MDS1.base $host | grep -v '^<' |  grep -v '^[1-9]' >> diff_MDS.log 
done

#LOG
for host in `ls -1 *LOG*  | grep -v *LOG1.base`;
do 
	echo "######$host######" >> diff_LOG.log
	diff syschk.LOG1.base $host | grep -v '^<' |  grep -v '^[1-9]' >> diff_LOG.log 
done

#FIX
for host in `ls -1 *FIX*  | grep -v *FIXGW01P.base`;
do 
	echo "######$host######" >> diff_FIX.log
	diff syschk.FIXGW01P.base $host | grep -v '^<' |  grep -v '^[1-9]' >> diff_FIX.log 
done

#TS
for host in `ls -1 *TS*  | grep -v *TS1.base`;
do 
	echo "######$host######" >> diff_TS.log
	diff syschk.TS1.base $host | grep -v '^<' |  grep -v '^[1-9]' >> diff_TS.log 
done
