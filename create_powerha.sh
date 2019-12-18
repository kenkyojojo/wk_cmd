#!/usr/bin/ksh
Cluster_name="FIXGW01_Cluster"
Node1="FIXGW01P"
Node2="FIXGW01B"
Nodes="${Node1},${Node2}"
Appname="FIXGW01_APP"
StartAP="/home/startAP.sh"
StopAP="/home/stopAP.sh"
RG1="RG1"
RG2="RG2"
RGS="${RG1},${RG2}"
Repositories="hdisk4"
Serverip1="FIXGW01_SRV1"
Serverip2="FIXGW01_SRV2"
Net1="net_ether_01"
Net2="net_ether_02"
HAPATH="/usr/es/sbin/cluster/utilities"
####################################################################

# create cluster node and CAA_disk
Create_cluster () {
	${HAPATH}/clmgr add cluster $Cluster_name nodes=${Nodes} HEARTBEAT_TYP=multicast REPOSITORIES=${Repositories}
}

# clean cluster network
Clean_network () {
	${HAPATH}/clmgr rm ne all
}

# create cluster network
Create_network () {
	${HAPATH}/clmgr add ne $Net1 type=ether netmask=255.255.255.0 public=false
	${HAPATH}/clmgr add ne $Net2 type=ether netmask=255.255.255.0 public=false
}

# create cluster network interface
Create_network_if () {
# network 1
	${HAPATH}/clmgr add if FIXGW01P_BOOT1 network=${Net1} type=ether node=${Node1}
	${HAPATH}/clmgr add if FIXGW01B_BOOT1 network=${Net1} type=ether node=${Node2}

# network 2
	${HAPATH}/clmgr add if FIXGW01P network=${Net2} type=ether node=${Node1}
	${HAPATH}/clmgr add if FIXGW01B network=${Net2} type=ether node=${Node2}
}


# create cluster network service ip
Create_service_ip () {
	${HAPATH}/clmgr add service_ip $Serverip1 NETWORK=${Net1} NETMASK=255.255.255.0
	${HAPATH}/clmgr add service_ip $Serverip2 NETWORK=${Net2} NETMASK=255.255.255.0
}

# create cluster APP for start and stop
Create_app () {
	${HAPATH}/clmgr add app $Appname startscript=${StartAP} stopscript=${StopAP}
}

# create cluster RG
Create_rg () {
# RG1 have applications datavg service_label and application
	${HAPATH}/clmgr add rg $RG1 nodes=${Nodes} service_label=${Serverip1} FALLBACK=NFB applications=${Appname} volume_group=datavg
# RG2 or mor RG only have service_label
	${HAPATH}/clmgr add rg $RG2 nodes=${Nodes} service_label=${Serverip2} FALLBACK=NFB
}
# creat dependency for resource
Create_dep () {
# create cluster dependency RG for parent and child
	${HAPATH}/clmgr add dep parent=${RG1} child=${RG2}

# create cluster dependency for same node RGs
	${HAPATH}/clmgr add dep same=node groups=${RGS}
}

# cluster sync
Cluster_sync () {
	${HAPATH}/clmgr sync cl
}

main () { 

	Create_cluster
	Cluster_sync

	Clean_network
	Cluster_sync

	Create_network
	Cluster_sync

	Create_network_if
	Cluster_sync

	Create_service_ip
	Cluster_sync

	Create_app
	Cluster_sync

	Create_rg
	Cluster_sync

	Create_dep
	Cluster_sync
}

main
