#!/bin/bash
# meetings_rsync_domU.sh, 2018-08-16 / Meetin.gs

. /usr/local/lib/libmeetings.sh "rsync"

wait_for_lock

NAME=${1:-}
HOST=${2:-}
SIZE=${3:-}
LIMIT=${4:-4096}
VG=vg0
FSTYPE=ext4
CFG=/etc/xen/$NAME.cfg
CRYPTTAB=/etc/crypttab
MOUNTPOINT=$(mktemp -d)
KEYFILE=/run/cryptsetup.asc
RSYNC_OPTS="-azAX -e ssh -B 8192 --stats"
if [ "$(rsync --version | grep 3.0.)" == "" ]; then
  RSYNC_OPTS+=" --info=progress2"
fi
RSYNC_OPTS+=" --numeric-ids --compress-level=1 --bwlimit=${LIMIT}"
RSYNC_OPTS+=" --exclude='$MOUNTPOINT/dev/*'"
RSYNC_OPTS+=" --exclude='$MOUNTPOINT/mnt/*'"
RSYNC_OPTS+=" --exclude='$MOUNTPOINT/media/*'"
RSYNC_OPTS+=" --exclude='$MOUNTPOINT/proc/*'"
RSYNC_OPTS+=" --exclude='$MOUNTPOINT/run/*'"
RSYNC_OPTS+=" --exclude='$MOUNTPOINT/sys/*'"
RSYNC_OPTS+=" --exclude='$MOUNTPOINT/tmp/*'"
RSYNC_OPTS+=" --exclude='$MOUNTPOINT/lost+found'"
REMOTE_SCRIPT=/usr/local/sbin/meetings_brace_for_domU.sh

ECFGCPY="unable to copy the domU configuration"
EOCRYPT="unable to open encrypted volume"
EPHYVOL="volume not found"
EMTNSRC="unable to mount the source volume"
EREMOTE="failed to prepare remote host"
EREMUMT="failed to perform clean up on target host"
EUMOUNT="failed to umount source volume"
EVOLREN="failed to rename volume"
ELUKSCL="failed to close luks volume"

say() { echo; echo " *** $@"; }

open_crypt_volume() {
  [ -e $SRCVOL ] && return
  cryptsetup luksOpen -d $KEYFILE $LOGVOL ${NAME}-disk || err $EOCRYPT
}

if [ $(id -u) -ne 0 ]; then
  err "root privileges required"
fi

if [ -z "$NAME" -o -z "$HOST" ]; then
  echo "Usage:"
  echo " ${0##*/} <domU_name> <target_host> [new_size=same] [speed_limit=4096]"
  exit 0
fi

if [ ! -f $CFG ]; then
  err "configuration ${CFG} not found"
fi

say "Setting rsync speed limit to ${LIMIT} kBps"

say "Copying domU configration."
rsync -a -e ssh $CFG $HOST:/etc/xen/ || err $ECFGCPY

# Find out if we are dealing with an encrypted or vanilla
# volume. Set variables LOGVOL and SRCVOL accordingly.
#
if [ -e /dev/${VG}/${NAME}-disk ]; then
  LOGVOL=/dev/${VG}/${NAME}-disk
  SRCVOL=/dev/${VG}/${NAME}-disk
elif [ -e /dev/${VG}/${NAME}-crypt ]; then
  LOGVOL=/dev/${VG}/${NAME}-crypt
  SRCVOL=/dev/mapper/${NAME}-disk
  open_crypt_volume $LOGVOL
else
  err $EPHYVOL
fi

SRCSIZE=$(lvdisplay -c $LOGVOL | awk -F: '{print $7 "s"}')
NEWSIZE=${SIZE:-$SRCSIZE}
say "Size of the new volume: $NEWSIZE"

say "Mounting source disk."
mount -t $FSTYPE -v $SRCVOL $MOUNTPOINT || err $EMTNSRC

say "Entering to remote host. Remember UPPERCASE YES!"
ssh -t $HOST $REMOTE_SCRIPT $NAME $NEWSIZE $MOUNTPOINT || err $EREMOTE

say "Source disk usage:"
df -h $MOUNTPOINT

echo "Ready to transfer the domU."
echo "Continue?"
read -p "> " -r
if [[ $REPLY =~ ^[yY] ]]; then
  time rsync $RSYNC_OPTS $MOUNTPOINT/* $HOST:$MOUNTPOINT/
else
  umount -v $MOUNTPOINT
  exit 0
fi

say "Finishing touch on remote host."
ssh $HOST "umount -v $MOUNTPOINT; rmdir -v $MOUNTPOINT" || err $EREMUMT

say "Cleaning up."
umount -v $MOUNTPOINT || err $EUMOUNT
rmdir -v $MOUNTPOINT

if [ "$LOGVOL" == "$SRCVOL" ]; then
  lvrename $VG $NAME-disk $NAME-moved || err $EVOLREN
else
  cryptsetup -v luksClose ${NAME}-disk || err $ELUKSCL
  sleep 1
  lvrename $VG $NAME-crypt $NAME-moved || err $EVOLREN
fi

grep -v "$NAME" $CRYPTTAB | sponge $CRYPTTAB
mv -fv $CFG ${CFG/cfg/moved}

say "OK"
