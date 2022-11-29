
## Installing Xen virtualization in Ubuntu Precise

1. Install Xen, dnsmasq and ethtool.

        # apt-get install xen-hypervisor-4.1-amd64 xen-tools dnsmasq ethtool

2. Fake create Precise hook script.

        # cd /usr/lib/xen-tools
        # ln -s karmic.d precise.d

3. To use bridged networking, see that /etc/xen/xend-config.sxp has lines:

        (network-script 'network-bridge bridge=br0')
        (vif-script 'vif-bridge bridge=br0')

   Also no other network-script or vif-script should be in use.

4. Configure dnsmasq. Following should be ok:

        interface=br0
        dhcp-range=10.0.0.10,10.0.0.100,12h

5. To attach dnsmasq to the bridge, create an alias interface by adding
   following lines to /etc/network/interfaces:

        iface br0:0 inet static
          address 10.0.0.1
          netmask 255.255.255.0
          broadcast 10.0.0.255

   Fixme! Is the following still valid?

   > Notice, however, br0:0 should not be started by Ubuntu networking
   scripts, because br0 does not exists at that point. Therefore there
   should NOT be any 'auto br0:0' line in interface definition file.

6. To bring up bridge alias at later state of the boot, add following
   line to /etc/rc.local (somewhere before 'exit 0'):

        ifup "br0:0" >/dev/null

7. To circumvent a long-standing udp checksum bug, disable udp
   checksumming from virtual network interface after the interface
   is created. To do this, /etc/xen/scripts/vif-bridge must be
   modified in following manner:

   * Open vif-bridge script with sensible editor
   * Locate argument parsing near the end of file (case "$command")
   * To 'online' section after 'add\_to\_bridge' command add line:

            ethtool -K ${dev} tx off


### NOTES

 * Default toolstack (xm) can be switched (to xl) by modifying
   /etc/default/xen. DON'T DO THAT! Although xm has been deprecated
   for a long time, use it, or be prepared to fix everything again
   with xl.

 * You may call your bridge whatever you want. If br0 does not suit you,
   change it in /etc/xen/xend-config.sxp, /etc/network/interfaces and
   /etc/rc.local.

 * For more information on the udp checksum bug see:
   http://google.fi/search?q=xen+bad+udp+checksum
