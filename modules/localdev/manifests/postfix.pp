/* Class: postfix
 *
 * 2014-03-06 / Meetin.gs
 */
class localdev::postfix() {
    package {
        ['postfix', 'mailutils']: ensure => installed
    }

    file {
        '/etc/mailname':
            mode    => 0644,
            source  => 'puppet:///modules/localdev/mailname';
        '/etc/postfix/main.cf':
            mode    => 0644,
            source  => 'puppet:///modules/localdev/main.cf',
            require => Package['postfix'];
        '/etc/postfix/virtual':
            mode    => 0644,
            source  => 'puppet:///modules/localdev/virtual',
            require => Package['postfix'],
            notify  => Exec['dovirtualdb'];
    }

    exec { 'dovirtualdb':
        command     => 'postmap /etc/postfix/virtual',
        onlyif      => 'test -f /etc/postfix/virtual',
        path        => ['/usr/bin', '/usr/sbin'],
        refreshonly => true;
    }

    service { 'postfix':
        enable    => true,
        ensure    => running,
        require   => Package['postfix'],
        subscribe => Exec['dovirtualdb'];
    }
}
