#!/bin/sh

cat >/etc/apt/sources.list <<EOL
deb http://fi.archive.ubuntu.com/ubuntu trusty main universe
deb http://fi.archive.ubuntu.com/ubuntu trusty-updates main universe
deb http://security.ubuntu.com/ubuntu trusty-security main universe
EOL

cat >/etc/apt/apt.conf.d/99translations <<EOL
Acquire::Languages "none";
EOL

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install --yes --no-install-recommends git puppetmaster-passenger
