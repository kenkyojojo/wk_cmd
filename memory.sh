#!/usr/bin/ksh

# This script monitors ConfigRM memory growth (if any) over time.
# The "SZ" and "RSS" columns will be of primary interest:
#
#   USER          PID %CPU %MEM   SZ  RSS    TTY    ...  COMMAND
#   root      9896000  0.0  2.0 27468 38732         ...  IBM.ConfigRMd
#                               ^^^^^ ^^^^^
#
# Under the effects of IV66606, on the Group Leader node, these sizes should
# grow a little every hour, and should at least show growth every 6 hours,
# which is the timeframe of the sleep used below.

while true; do
   date >> /tmp/configrm_size.out
   ps waux | grep ConfigRM >> /tmp/configrm_size.out
   sleep 21600
done

