#!/bin/sh

update-rc.d -f puppet remove
service puppet stop

cd /etc
rm -rf puppet
git clone /vagrant puppet

sed -i '/^#. .etc.default.locale/s/^#//' /etc/apache2/envvars #sed <3

cat >/etc/apache2/conf-available/000-name.conf <<EOL
ServerName puppet
EOL

a2enconf 000-name
service apache2 restart
