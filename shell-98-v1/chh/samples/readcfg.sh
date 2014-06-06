#! /bin/bash

shopt -s -o nounset
declare -a KEY
declare -a VALUE
declare -i k=1

while read N V 
do
    KEY[$k]=$N
    VALUE[$k]=$V
    ((k++))
done < <(awk 'BEGIN{FS=": "} /\w: \w/ {print $1, $2}' sapp.conf)

echo "${KEY[2]} = ${VALUE[2]}"
