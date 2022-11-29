#!/bin/bash
# meetings_fsarchive.sh, 2015-03-20 / Meetin.gs

. /usr/local/lib/libmeetings.sh

NAME=${1:-}
FSA=$(date +%F)-$NAME.fsa
VOL=/dev/mapper/${NAME}-disk

EDOMUR="unable to continue because domU is running"
ENOVOL="cannot find volume for $NAME"

if [ -z "$NAME" ]; then
  echo "Usage:"
  echo " ${0##*/} <domU_name>"
  exit 0
fi

if [ $(id -u) -ne 0 ]; then
  err "root privileges required"
fi

xl list $NAME 2> /dev/null && err $EDOMUR

[ -e $VOL ] || err $ENOVOL

syslog_everything "fsa"

fsarchiver -z 2 savefs /root/${FSA} ${VOL}

if [ "${2:-}" == "start" ]; then
  sleep 4
  xl create /etc/xen/${NAME}.cfg
fi
