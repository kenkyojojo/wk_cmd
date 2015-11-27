#!/usr/bin/ksh
HA_CSP="/usr/es/sbin/cluster/cspoc"
HA_CMD="/usr/es/sbin/cluster/utilities"
LOGDIR="/home/se/safechk/safelog"
LOG="${LOGDIR}/menu.log"

#stop HA
${HA_CSP}/fix_args nop cl_clstop -N -cspoc-n 'FIXGW02P,FIXGW02B' -g >/dev/null 2>&1
#start HA
${HA_CSP}/fix_args nop cl_rc.cluster -N -cspoc-n 'FIXGW02P,FIXGW02B' -A  -C interactive > /dev/null 2>&1
