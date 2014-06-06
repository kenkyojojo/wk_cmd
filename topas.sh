#!/bin/ksh

DIR=/tmp/topaslog

while true; do 
    DATE=`date +%Y%m%d`
    timestamp=`date +"%Y/%m/%d %H:%M:%S"`
    
    echo $timestamp >> $DIR/topas.$DATE
    echo "                                DATA  TEXT  PAGE               PGFAULTS           " >> $DIR/topas.$DATE
    echo "USER        PID    PPID PRI NI   RES   RES SPACE    TIME CPU%  I/O  OTH COMMAND" >> $DIR/topas.$DATE
    (sleep 3;echo q)|topas -P|head -17|tail -10 >> $DIR/topas.$DATE
    #cat $DIR/topas.$DATE | col -b > $DIR/topas.$DATE
    sleep 600
    echo "" >> $DIR/topas.$DATE
done
