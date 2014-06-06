#!/usr/bin/ksh

if [ $# -ne 1 ]; then
    echo "Usage: send_hb.sh <count>"
    exit 0
fi

COUNT=$1
while [ "0" = "0" ]; do
    ibsmon_np_client 0 0 > /dev/null 2>&1
    RC=$?
    if [ "$RC" != 0 ]; then
        echo "RC = $RC"
        exit $RC
    fi

    MOD=$(($COUNT % 1000))
    if [ "$MOD" = "0" ]; then
        echo "Process ${COUNT}-th messages"
    fi

    COUNT=$(($COUNT - 1))
    if [ "$COUNT" = "0" ]; then
        exit 0
    fi
done