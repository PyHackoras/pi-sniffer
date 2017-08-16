#!/bin/bash
#
# autoscan - simple auto scanner for kali linux on raspberry pi
 
source /root/.autoscan.cfg
 
airmon-ng start ${AIRMON_DEV}
 
while [ ! -e "/tmp/.autoscan.stop" ]; do
airodump-ng -w ${STORAGE} ${AIRODUMP_OPTS} ${AIRMON_MON} > /dev/null 2>&1 &
PID=$!
sleep ${RUN_TIME}
kill ${PID}
FS="$(df `dirname ${STORAGE}` | tail -n1 | awk '{print $4}')"
test ${FS} -lt ${SAFETY_NET} && touch "/tmp/.autoscan.stop"
done
 
airmon-ng stop ${AIRMON_MON}
