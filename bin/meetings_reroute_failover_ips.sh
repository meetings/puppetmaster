#!/bin/bash
# meetings_reroute_failover_ips.sh, 2014-05-18 / Meetin.gs

echo WARNING DEPRECATED
echo As of 2014-09-12, this script does not work.
echo Please fix if needed.

exit 0

DEFAULT_IPS="78.46.26.1 176.9.12.105 176.9.12.106"
ROBOT_ADDR="https://robot-ws.your-server.de/failover"
ROBOT_USER=dicoleoy
ROBOT_PASSWD=

echo
echo "Enter the failover IPs which ought to be rerouted:"
echo "[$DEFAULT_IPS] 176.9.15.204"
read -p "> " INPUT

FAILOVER_IPS=${INPUT:-$DEFAULT_IPS}

echo
echo "Select target host:"

select TARGET_NAME in kukka pilvi jojo yrtti ruoho keksi myssy savu; do
    case $TARGET_NAME in
        kukka) TARGET_IP=88.198.37.108; break;;
        pilvi) TARGET_IP=88.198.37.107; break;;
        jojo)  TARGET_IP=85.10.196.41;  break;;
        yrtti) TARGET_IP=144.76.84.100; break;;
        ruoho) TARGET_IP=144.76.85.147; break;;
        keksi) TARGET_IP=5.9.41.212;    break;;
        myssy) TARGET_IP=5.9.41.213;    break;;
        savu)  TARGET_IP=46.4.71.238;   break;;
    esac
done

echo
echo "Type the password for the robot:"
read -p "[no echo] " -s ROBOT_PASSWD
echo

for IP in $FAILOVER_IPS; do
    echo
    echo "$IP => $TARGET_NAME.dicole.com:"
    curl --data   "active_server_ip=$TARGET_IP" \
         --user   "$ROBOT_USER:$ROBOT_PASSWD"   \
         --silent "$ROBOT_ADDR/$IP" | python -mjson.tool
done
