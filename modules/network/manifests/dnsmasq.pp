/* Class: dnsmasq
 *
 * 2014-12-31 / Meetin.gs
 */
class network::dnsmasq() {
    package {
        'dnsmasq': ensure => installed;
    }

    file { '/etc/dnsmasq.conf':
        mode    => 0644,
        source  => 'puppet:///modules/network/dnsmasq.conf',
        require => Package['dnsmasq'];
    }
}
