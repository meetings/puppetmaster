#!/bin/bash
# meetings_dhcpd_replacer.sh, 2015-01-08 / Meetin.gs

. /usr/local/lib/libmeetings.sh

set -u

NAME=${1:-}
CFG=/etc/xen/${NAME}.cfg
MOUNTPOINT=$(mktemp -d --suffix=.$NAME)
NETDIR=$MOUNTPOINT/etc/network

[ -z ${NAME} ] && err "usage: ${0##*/} <name>"
[ -f ${CFG} ]  || err "configuration not found: ${CFG}"

if [ -e /dev/mapper/${NAME}-disk ]; then
  DISK=/dev/mapper/${NAME}-disk
elif [ -e /dev/vg0/${NAME}-disk ]; then
  DISK=/dev/vg0/${NAME}-disk
else
  err "${NAME}: physical volume not found"
fi

/usr/local/sbin/meetings_mac_to_ip.pl < ${CFG} | sponge ${CFG}

IP=$(grep ^vif ${CFG} | sed 's/.*ip=//;s/,.*//')

echo ${NAME}: ${IP}

mount -t ext4 ${DISK} ${MOUNTPOINT} || err "failed to mount ${DISK}"

cat >$NETDIR/interfaces <<EOL
auto lo
allow-hotplug eth0

iface lo inet loopback

iface eth0 inet static
  address ${IP}
  netmask 255.0.0.0
  gateway 10.0.0.1
  post-up ethtool -K eth0 tx off
EOL

umount ${MOUNTPOINT}
rmdir ${MOUNTPOINT}
