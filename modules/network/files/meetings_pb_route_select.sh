#!/bin/bash
# meetings_pb_route_select.sh, 2014-11-10 / Meetin.gs

PATH=$PATH:/sbin
PBLIB=/usr/local/lib/pb

fail() {
    echo
    echo "Running iptables(8) failed."
    echo "Make sure you are carrying root permissions."
    echo
    exit 1
}

usage() {
    echo "Usage: ${0##*/} <service> <normal | 1 | 2>"
    echo "Services: $(ls -1 $PBLIB | xargs echo)"
    echo "Current state:"
    iptables -L -n -t nat | grep REDIRECT | cut -b 63- | sed 's/^/  /'
    exit 1
}

ipt_add() {
    tty -s && echo "   $PB_SERVICE: $PB_PUBLIC ~> $1"
    iptables -t nat -A OUTPUT -p tcp --dport $PB_PUBLIC \
        -j REDIRECT --to-port $1
}

ipt_del() {
    iptables -t nat -D OUTPUT -p tcp --dport $PB_PUBLIC \
        -j REDIRECT --to-port $1 2> /dev/null || true
}

SERVICE=$1
MODE=$2

iptables -L -n -t nat &> /dev/null || fail

. $SERVICE 2>/dev/null || \
  . $PBLIB/$SERVICE 2>/dev/null || \
    . $PBLIB/$SERVICE.conf 2>/dev/null || usage

if [[ "$MODE" == n* ]]; then
    TARGET=$PB_PORT_N
elif [ "$MODE" == "1" ]; then
    TARGET=$PB_PORT_1
elif [ "$MODE" == "2" ]; then
    TARGET=$PB_PORT_2
else
    usage
fi

ipt_del $PB_PORT_N
ipt_del $PB_PORT_1
ipt_del $PB_PORT_2
ipt_add $TARGET
