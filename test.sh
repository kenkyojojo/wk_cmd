#!/usr/bin/ksh
Cluster_name="FIXGW01_Cluster"
Node1="FIXGW01P"
Node2="FIXGW01B"
Nodes="$Node1 $Node2"
Appname="FIXGW01_APP"
StartAPP="/home/startAP.sh"
StopAPP="/home/stopAP.sh"
RGlist="RG1 RG2"

for FF in $Nodes
do

echo $FF

done
