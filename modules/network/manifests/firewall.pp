/* Class: firewall
 *
 * Bring up the firewall and enable Network Address Translation
 * so that domUs can go and prance around the Internetz.
 *
 * 2014-02-10 / Meetin.gs
 */
class network::firewall($public_ip, $public_iface, $internal_ip, $internal_subnet, $internal_iface) {
    /* Set kernel parameters.
     */
    dom0::sysctl {
        # Lets go routing! This is critical for nat.
        'net.ipv4.ip_forward': value => 1;

        # Disable icmp redirects. They should not be of any value in
        # sane network, but can provide a base for mitm attacks.
        'net.ipv4.conf.all.accept_redirects':     value => 0;
        'net.ipv4.conf.default.accept_redirects': value => 0;
        'net.ipv6.conf.all.accept_redirects':     value => 0;
        'net.ipv6.conf.default.accept_redirects': value => 0;

        # Choose to ignore harmful icmp packets.
        'net.ipv4.icmp_echo_ignore_all':              value => 0;
        'net.ipv4.icmp_echo_ignore_broadcasts':       value => 1;
        'net.ipv4.icmp_ignore_bogus_error_responses': value => 1;

        # Completely ignore silly packets which do not belong here.
        'net.ipv4.conf.all.log_martians':     value => 0;
        'net.ipv4.conf.default.log_martians': value => 0;
    }

    /* Drop a firewall script. Template uses:
     *  $public_ip
     *  $public_iface
     *  $internal_ip
     *  $internal_subnet
     *  $internal_iface
     */
    file { 'palomuuri.sh':
        path    => '/usr/local/sbin/palomuuri.sh',
        mode    => '0750',
        content => template('network/palomuuri.sh.erb');
    }

    /* Initiate firewall when puppet(8) is run.
     *
     * Note! Firewall script is also run at boot. That is taken
     * care by rc.local, which is configured elsewhere.
     */
    exec { 'palomuuri.sh':
        onlyif      => 'test -f /usr/local/sbin/palomuuri.sh',
        path        => ['/usr/bin', '/usr/local/sbin'],
        subscribe   => File['palomuuri.sh'],
        refreshonly => true;
    }
}
