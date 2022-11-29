/* Class: domu
 *
 * 2015-01-12 / Meetin.gs
 */
class network::domu($iface=undef) inherits network {
    /* All the domUs should have valid interfaces(5) configuration
     * except for fronts, which require aliases.
     */
    if $iface {
        file { '/etc/network/interfaces':
            mode    => 0644,
            content => template('network/interfaces.front.erb');
        }
    }

    file {
        '/etc/resolvconf/resolv.conf.d/head':
            mode   => 0644,
            source => 'puppet:///modules/network/resolvconf/head',
            notify => Exec['resolvconf'];
        '/etc/resolvconf/resolv.conf.d/base':
            mode   => 0644,
            source => 'puppet:///modules/network/resolvconf/base',
            notify => Exec['resolvconf'];
        '/etc/resolvconf/resolv.conf.d/tail':
            mode   => 0644,
            source => 'puppet:///modules/network/resolvconf/tail',
            notify => Exec['resolvconf'];
    }

    exec { 'resolvconf':
        command     => '/sbin/resolvconf -u',
        refreshonly => true;
    }
}
