#!/usr/bin/ksh

DATE=`/usr/bin/date +"%y%m%d"`
HOST=`/usr/bin/hostname`
ERROR=/home/se/safechk/safelog/Backup_OSimg.err
LOG=/home/se/safechk/safelog/Backup_OSimg.log
MKLIST=/home/se/safechk/safelog/mksysb.lst
TARGETDIR=/backup
counterLimit=2
counter=0

#
# check error log file for any contents whatsoever
#
errlogchk(){

        if [[ -s $ERROR ]]; then
                echo "Error Found"
                if [[ $counter -lt $counterLimit ]]; then
                        echo "Retrying mksysb"
                        runmksysb
                else
                        echo "mksysb failed $counterLimit times and therefore is quitting"
#                        mail -s "Error in mksysb for $HOST" user@group.com < $ERROR
#                        umount /backup
                        exit 2
                fi
        else
                echo "No Error Found"
#                umount /backup
                exit 0
        fi

}

runmksysb(){

#
# on exit of any kind, check err log and perform actions if greater
# than 0 bytes

        trap "errlogchk" KILL TERM QUIT HUP EXIT

#
# counter for error check to retry mksysb
#
        let counter+=1

        echo "Performing mksysb for the $counter time"

#
# aggregate volume group list
#
        for i in `lsvg`; do
        if [ $i != "rootvg" ]; then
                echo "Collecting data for vg $i"
                savevg -i -r -f /etc/savevg.$i $i
        fi
        done

#
# mount nim server
#
#        mount -o soft nimsrv:/nim/mksysb/ /backup 2>$ERROR

#
# perform mksysb
#
        if [[ $HOST == "VIOS1" || $HOST == "VIOS2" ]]; then

			/usr/ios/cli/ioscli backupios -file /home/backup/$HOST.$DATE.mksysb -mksysb 1>>$LOG 2>$ERROR

		else

        	/usr/bin/mksysb -i -X -e -p $TARGETDIR/$HOST.$DATE.mksysb 1>>$LOG 2>$ERROR
		fi
        sleep 60
#
# list backup file details
#
        if [[ $HOST == "VIOS1" || $HOST == "VIOS2" ]]; then
			listvgbackup -f /home/backup/$HOST.$DATE.mksysb > $MKLIST
		else
        	listvgbackup -f $TARGETDIR/$HOST.$DATE.mksysb > $MKLIST
		fi

}

#
# initial run of mksysb
#
runmksysb
