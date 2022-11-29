#!/bin/bash
# meetings_get_secrets.sh, 2013-12-11 / Meetin.gs

SRC=${1:-gateway.dicole.com}

ssh $SRC 'sudo tar cf - -C /var/run cryptsetup.asc gpg' | sudo tar xvf - -C /var/run
