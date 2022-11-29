/* Class: timezone
 *
 * Change host timezone to UTC.
 *
 * 2013-11-23 / Meetin.gs
 */
class common::timezone() {
    tag 'bootstrap'

    file { '/etc/timezone':
        mode   => 0644,
        source => 'puppet:///modules/common/timezone',
        notify => Exec['reconfig-tzdata'];
    }

    file { '/etc/localtime':
      ensure => 'link',
      target => '/usr/share/zoneinfo/Etc/UTC',
    }

    exec { 'reconfig-tzdata':
        command     => 'dpkg-reconfigure -f noninteractive tzdata',
        path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        refreshonly => true;
    }
}
