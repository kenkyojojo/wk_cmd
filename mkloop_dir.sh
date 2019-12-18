#!/usr/bin/bash
loopmkdir2019(){
YEAR=2019
for i in $(seq 1 12)
do
  printf  -v var "%02d"  "${i}"
  echo "mkdir -p /tmp/RCMS/Report/source/${YEAR}${var}"
  mkdir -p /tmp/RCMS/Report/source/${YEAR}${var}
  for j in $(seq 1 31)
  do
    printf  -v jvar "%02d"  "${j}"
    echo "mkdir /tmp/RCMS/Report/source/${YEAR}${var}/$jvar"
    mkdir /tmp/RCMS/Report/source/${YEAR}${var}/$jvar
    echo "${YEAR}${var}_${jvar} data log" > /tmp/RCMS/Report/source/${YEAR}${var}/$jvar/RC2_${YEAR}${var}${jvar}.log
  done
done
}

loopmkdir2018(){
YEAR=2018
for i in $(seq 1 12)
do
  printf  -v var "%02d"  "${i}"
  echo "mkdir -p /tmp/RCMS/Report/source/${YEAR}${var}"
  mkdir -p /tmp/RCMS/Report/source/${YEAR}${var}
  for j in $(seq 1 31)
  do
    printf  -v jvar "%02d"  "${j}"
    echo "mkdir /tmp/RCMS/Report/source/${YEAR}${var}/$jvar"
    mkdir /tmp/RCMS/Report/source/${YEAR}${var}/$jvar
    echo "${YEAR}${var}_${jvar} data log" > /tmp/RCMS/Report/source/${YEAR}${var}/$jvar/RC2_${YEAR}${var}${jvar}.log
  done
done
}
main (){
  loopmkdir2018
  loopmkdir2019
}
main
