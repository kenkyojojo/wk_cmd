#!/bin/ksh
DIR=/tmp/RCMS/Report/source
REPORT_DIR=/tmp
REPORT=${REPORT_DIR}/RC2_merge_201810-201910.log
RC2_2018 () {
BEG=10
END=12
YEAR=2019
    while (( $BEG <= $END )) 
    do
      find ${DIR}/${YEAR}${BEG} -type f -name 'RC2*.log' | sort | xargs cat - > $REPORT
      (( BEG=$BEG+1 )) 
    done
}
RC2_2019 () {
BEG=1
END=12
YEAR=2019
    while (( $BEG <= $END )) 
    do
      find ${DIR}/${YEAR}${BEG} -type f -name 'RC2*.log' | sort | xargs cat - >> $REPORT
      (( BEG=$BEG+1 )) 
    done
}

main () {
  RC2_2018
  RC2_2019
}
main
