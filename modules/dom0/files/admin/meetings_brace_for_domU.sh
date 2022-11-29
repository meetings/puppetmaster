#!/bin/bash
# meetings_brace_for_domU.sh, 2014-11-20 / Meetin.gs

. /usr/local/lib/libmeetings.sh "brace"

wait_for_lock

set -e

NAME=${1}
SIZE=${2}
MOUNTPOINT=${3}
VG=/dev/vg0
FSTYPE=ext4
CRYPTTAB=/etc/crypttab
KEYFILE=/run/cryptsetup.asc

if [ $(id -u) -ne 0 ]; then
  err "root privileges required"
fi

if [ ! -f $KEYFILE ]; then
  err "crypto key not found"
fi

mkdir $MOUNTPOINT

lvcreate -L ${SIZE} -n ${NAME}-crypt $VG
cryptsetup luksFormat $VG/${NAME}-crypt $KEYFILE
cryptsetup luksOpen -d $KEYFILE $VG/${NAME}-crypt ${NAME}-disk
mke2fs -t $FSTYPE /dev/mapper/${NAME}-disk
mount -t $FSTYPE -v /dev/mapper/${NAME}-disk $MOUNTPOINT

echo "$NAME-disk $VG/${NAME}-crypt $KEYFILE luks" | tee -a $CRYPTTAB
column -t $CRYPTTAB | sponge $CRYPTTAB

exit 0
