#!/bin/ksh
DIR=/RCMS/Report/source
REPORT_DIR=/tmp
REPORT=${REPORT_DIR}/RC2_merge_201810-201910.log

RC2_2018 () {
BEG=10
END=12
YEAR=2018
    while (( $BEG <= $END ))
    do
      VARB=`echo $BEG | awk '{printf("%02d\n",$0)}'`
      find ${DIR}/${YEAR}${VARB} -type f -name "RC2*.log" | sort | xargs cat - >> $REPORT
      (( BEG=$BEG+1 ))
    done
}

RC2_2019 () {
BEG=1
END=10
YEAR=2019
    while (( $BEG <= $END ))
    do
      VARB=`echo $BEG | awk '{printf("%02d\n",$0)}'`
      find ${DIR}/${YEAR}${VARB} -type f -name "RC2*.log" | sort | xargs cat - >> $REPORT
      (( BEG=$BEG+1 ))
    done
}
main () {
  rm -f $REPORT
  RC2_2018
  RC2_2019
}
main
