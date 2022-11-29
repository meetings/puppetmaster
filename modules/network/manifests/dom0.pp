/* Class: dom0
 *
 * 2015-01-08 / Meetin.gs
 */
class network::dom0(
    $ipv6,
    $ip,
    $intip,
    $intsubnet,
    $netmask,
    $broadcast,
    $gateway,
    $subnet,
    $iface='eth0',
    $intiface='dicolerootnet',
) inherits network {
    class {
        'network::butterfly':;
        'network::dnsmasq':;
        'network::firewall':
            public_ip    => $ip,
            public_iface => $iface,
            internal_ip     => $intip,
            internal_subnet => $intsubnet,
            internal_iface  => $intiface;
    }

    /* Template uses:
     *  $ipv6
     *  $ip
     *  $netmask
     *  $broadcast
     *  $gateway
     *  $subnet
     */
    file { '/etc/network/interfaces':
        mode    => '0644',
        content => template('network/interfaces.dom0.erb');
    }
}
