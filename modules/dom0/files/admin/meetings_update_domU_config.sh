#!/bin/bash
# meetings_update_domU_config.sh, 2018-08-24 / Meetin.gs
#
# Reconfigure all domUs to use most recent kernel+initrd or pygrub
# and set correct upper limit to 'cpus'.

KERNEL=$(ls -t /boot/vmlinuz* | head -n1)
INITRD=$(ls -t /boot/initrd.img* | head -n1)
MAXCPU=$(xl info | awk '/^max_cpu_id/ {print $3}')

for CFG in /etc/xen/*.cfg; do

perl -ni -e "s/^(kernel|ramdisk|bootloader).*//s; print \$_ if \$_ ne ''" $CFG
perl -pi -e "s/^(cpus.*)/cpus        = '2-$MAXCPU'/" $CFG

if [ -f /etc/lsb-release ] && [ "$(grep precise /etc/lsb-release)" == "" ]; then

perl -pi -e "s/^(cpus.*)/bootloader  = 'pygrub'\\n\$1/" $CFG

else

perl -pi -e "BEGIN { our \$k='$KERNEL'; our \$r='$INITRD'} s/^(cpus.*)/kernel      = '\$k'\\nramdisk     = '\$r'\\n\$1/" $CFG

fi

done
THREADS=$(expr $MAXCPU - 1)
if [ -f /etc/lsb-release ] && [ "$(grep precise /etc/lsb-release)" == "" ]; then
echo "OK: pygrub with $THREADS threads"
else
echo "OK: $(basename $KERNEL) $(basename $INITRD) with $THREADS threads"
fi

