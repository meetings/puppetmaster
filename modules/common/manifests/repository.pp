/* Class: repository
 *
 * Add the Meetin.gs package repository
 * and the package signing key.
 *
 * 2014-10-06 / Meetin.gs
 */
class common::repository() {
    tag 'bootstrap'

    file { '/etc/apt/sources.list.d/meetin.gs.list':
        mode    => 0644,
        content => template('common/meetin.gs.list.erb'),
        notify  => Exec['package-key'];
    }

    exec { 'package-key':
        command     => 'wget http://ubuntu.meetin.gs/meetin.gs.asc -qO- | apt-key add -',
        path        => ['/bin', '/usr/bin'],
        unless      => 'apt-key list | grep -q Meetin.gs',
        refreshonly => true;
    }
}
