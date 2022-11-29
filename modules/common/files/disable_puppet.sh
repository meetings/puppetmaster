#!/bin/sh
#
# This file is managed and overwritten by Puppet. If you need
# to make changes, see the Puppetmaster and its configuration.
#
# Puppet agent should not run as daemon, if it seems to do so,
# disable and stop it.

if [ -f /var/run/puppet/agent.pid ]; then
  /usr/sbin/update-rc.d -f puppet remove
  /usr/sbin/service puppet stop
fi
