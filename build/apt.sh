#!/bin/bash

sed -i 's/^mesg n/tty -s \&\& mesg n/' /root/.profile

cat >/etc/apt/sources.list <<EOL
deb http://archive.ubuntu.com/ubuntu trusty main universe
deb http://archive.ubuntu.com/ubuntu trusty-updates main universe
deb http://security.ubuntu.com/ubuntu trusty-security main universe
EOL

cat >/etc/apt/apt.conf.d/99translations <<EOL
Acquire::Languages "none";
EOL

# basics:
PACKAGES=(git build-essential debhelper devscripts)

# fpm:
PACKAGES+=(ruby1.9.1-dev cpanminus)

# business-paypal-nvp:
PACKAGES+=(libssl-dev)

# xml-liberal:
PACKAGES+=(libxml2-dev)

# liblog-log4perl-appender-raven-perl:
PACKAGES+=(liblog-any-adapter-log4perl-perl)

# libsentry-raven-perl:
PACKAGES+=(libtest-warn-perl libtest-lwp-useragent-perl)

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install --yes --no-install-recommends ${PACKAGES[@]}
