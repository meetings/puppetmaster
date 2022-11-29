#!/bin/bash
# meetings_destroy_domU.sh, 2014-09-26 / Meetin.gs

VG=vg0
CRYPTTAB=/etc/crypttab

if [ $(id -u) -ne 0 ]; then
  echo "error: root privileges required"
  exit 1
fi

if [ -z "${1}" ]; then
  echo "Usage: ${0##*/} <name>"
  exit 0
fi

NAME=${1}
DISK=${NAME}-disk
CRYPT=${NAME}-crypt
CONFIG=/etc/xen/${NAME}.cfg

if [ ! -e $CONFIG ]; then
  echo "No domU configuration found. Don't know what to do."
  echo "Quitting."
  exit 1
fi

xl list $NAME 2> /dev/null && {
  echo "DomU seems to be running. Please, make it stop."
  echo "Quitting."
  exit 1
}

cryptdisks_stop $DISK
sed -i "/$DISK/d" $CRYPTTAB
rm -v $CONFIG
lvremove $VG/$CRYPT

exit 0
