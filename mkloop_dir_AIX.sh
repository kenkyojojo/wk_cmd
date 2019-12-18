#!/bin/ksh

loopmkdir2019(){
YEAR=2019
BEG=1
END=12
BEGD=1
ENDD=31
while (( $BEG <= $END ))
do
   var=`echo $BEG | awk '{printf("%02d\n",$0)}'`
   echo "mkdir -p /RCMS/Report/source/${YEAR}${var}"
   mkdir -p /RCMS/Report/source/${YEAR}${var}
  while (( $BEGD <= $ENDD ))
  do
    jvar=`echo $BEGD | awk '{printf("%02d\n",$0)}'`
    echo "mkdir -p /RCMS/Report/source/${YEAR}${var}/${jvar}"
    mkdir -p /RCMS/Report/source/${YEAR}${var}/${jvar}
    echo "${YEAR}${var}_${jvar} data log" > /RCMS/Report/source/${YEAR}${var}/$jvar/RC2_${YEAR}${var}${jvar}.log
    (( BEGD=$BEGD+1 ))
   done
   BEGD=1
  (( BEG=$BEG+1 ))
done
}

loopmkdir2018(){
YEAR=2018
BEG=1
END=12
BEGD=1
ENDD=31
while (( $BEG <= $END ))
do
   var=`echo $BEG | awk '{printf("%02d\n",$0)}'`
  echo "mkdir -p /RCMS/Report/source/${YEAR}${var}"
  mkdir -p /RCMS/Report/source/${YEAR}${var}
  while (( $BEGD <= $ENDD ))
  do
   jvar=`echo $BEGD | awk '{printf("%02d\n",$0)}'`
    echo "mkdir -p /RCMS/Report/source/${YEAR}${var}/${jvar}"
    mkdir -p /RCMS/Report/source/${YEAR}${var}/${jvar}
    echo "${YEAR}${var}_${jvar} data log" > /RCMS/Report/source/${YEAR}${var}/$jvar/RC2_${YEAR}${var}${jvar}.log
    (( BEGD=$BEGD+1 ))
   done
   BEGD=1
  (( BEG=$BEG+1 ))
done
}
main (){
  loopmkdir2018
  loopmkdir2019
}
main
