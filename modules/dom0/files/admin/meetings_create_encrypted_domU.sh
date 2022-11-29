#!/bin/bash
# meetings_create_encrypted_domU.sh, 2015-03-20 / Meetin.gs

. /usr/local/lib/libmeetings.sh

usage() {
  echo "Usage: ${0##*/} <name> [disksize=4G] [memory=512Mb] [dist=trusty]"
  echo "If TESTMODE is empty, domU is not started after creation,"
  echo "otherwise new root volume is mounted and domU is not started."
  exit 0
}

if [ $(id -u) -ne 0 ]; then
  echo "error: root privileges required"
  exit 1
fi

VG=vg0
CRYPTTAB=/etc/crypttab
KEYFILE=/run/cryptsetup.asc

NAME=${1:-}
DISK=${NAME}-disk
CRYPT=${NAME}-crypt
SIZE=${2:-4G}
MEMORY=${3:-512Mb}
DIST=${4:-trusty}
ARCH=${ARCH:-amd64}
CFG=/etc/xen/${NAME}.cfg
MOUNTPOINT=$(mktemp -d --suffix=.$NAME)

ECRK="cryptographic key not found"
ECFG="sanity check failed: ${NAME}.cfg exists"
ELVO="failed to create logical volume"
EENC="failed to initialize encryption"
ELVR="logical volume removed"
EOPN="failed to open luks volume"
EBOO="xen-create-image(8) failed"
ERUN="failed to start domU instance"
EMTN="failed to mount ${DISK}"
EUMT="failed to unmount ${MOUNTPOINT}"

[ -z "${NAME}" ] && usage
[ -f $KEYFILE ] || err $ECRK
[ -e /etc/xen/${NAME}.cfg ] && err $ECFG

lvcreate -L $SIZE -n $CRYPT $VG || err $ELVO

cryptsetup luksFormat /dev/${VG}/$CRYPT $KEYFILE
if [ $? != 0 ]; then
  echo -e "\n$EENC\n"
  lvremove $VG/$CRYPT
  err $ELVR
fi

cryptsetup luksOpen -d $KEYFILE /dev/${VG}/$CRYPT $DISK || err $EOPN

echo "${DISK} /dev/${VG}/${CRYPT} $KEYFILE luks,noauto" | tee -a $CRYPTTAB
column -t $CRYPTTAB | sponge $CRYPTTAB

echo -e "\nBootstrapping domU..."
echo -e "See /var/log/xen-tools/$NAME.log for details.\n"

xen-create-image \
  --dhcp \
  --arch=${ARCH} \
  --dist=${DIST} \
  --hostname=${NAME} \
  --memory=${MEMORY} \
  --image-dev=/dev/mapper/${DISK} \
  --role=meetings

if [ $? != 0 -o ! -f ${CFG} ]; then
  echo $EBOO
  rmdir ${MOUNTPOINT}
  exit 1
fi

/usr/local/sbin/meetings_mac_to_ip.pl < ${CFG} | sponge ${CFG}
IP=$(grep ^vif ${CFG} | sed 's/.*ip=//;s/,.*//')
echo -e "IP Address      :  ${IP}\n"

mount -t ext4 /dev/mapper/${DISK} ${MOUNTPOINT} || err $EMTN

if [ "${DIST}" == "trusty" ]; then
    cat >$MOUNTPOINT/etc/network/interfaces <<EOL
auto lo eth0

iface lo inet loopback

iface eth0 inet static
  address ${IP}
  netmask 255.255.255.255
  post-up ip route add 0.0.0.0/0 dev eth0
EOL
else
    cat >$MOUNTPOINT/etc/network/interfaces <<EOL
auto lo eth0

iface lo inet loopback
  dns-nameservers 10.0.0.1

iface eth0 inet static
  address ${IP}
  netmask 0.0.0.0
  gateway 10.0.0.1
EOL
fi

if [ -n "${TESTMODE:-}" ]; then
  echo
  echo " *** TESTMODE"
  echo "New domU is mounted to ${MOUNTPOINT}."
  echo "Type exit to leave temporary shell."
  echo " *** TESTMODE"
  echo
  bash
fi

umount -v ${MOUNTPOINT} || err $EUMT
rmdir ${MOUNTPOINT}
echo

if [ -z "${TESTMODE:-}" ]; then
  xl create /etc/xen/${NAME}.cfg || err $ERUN
  echo "Booting ${NAME} for provisioning"
else
  echo "OK, next:"
  echo " xl create /etc/xen/${NAME}.cfg"
  echo " ssh root@${IP}"
fi
