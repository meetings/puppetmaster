#!/bin/bash
# meetings_sudo_rsync_domU.sh, 2018-08-16 / Meetin.gs

NAME=${1:-}
HOST=${2:-}
SIZE=${3:-}
LIMIT=${4:-}

say() { echo; echo " *** $@"; }

if [ -z "$NAME" -o -z "$HOST" ]; then
  echo "Usage:"
  echo " ${0##*/} <domU_name> <target_host> [new_size=same] [speed_limit=4096]"
  exit 0
fi

say "Inserting temporary root key to $HOST..."

sudo cat /root/.ssh/id_rsa.pub | perl -pe 's/(.*)/$1 # tmprsynckey/' | ssh $HOST sudo sh -c "'cat >> /root/.ssh/authorized_keys'"

say "Starting real rsync script with params $NAME $HOST \"$SIZE\" \"$LIMIT\"..."

sudo /usr/local/sbin/meetings_rsync_domU.sh $NAME $HOST "$SIZE" "$LIMIT"

say "Removing temporary root key from $HOST..."

ssh $HOST sudo sh -c "'grep -v tmprsynckey /root/.ssh/authorized_keys | sponge /root/.ssh/authorized_keys'"

say "Sudo Rsync Done."
