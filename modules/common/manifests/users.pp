/* Class: users
 *
 * Add administrative user account with public key
 * authentication and permission to to anything
 * with sudo(8).
 *
 * 2014-12-31 / Meetin.gs
 */
class common::users() {
    tag 'bootstrap'

    common::adduser {
        'amv':
            comment => 'Antti Vähäkotamäki',
            groups  => ['adm', 'syslog'],
            super   => true;
        'tuomas':
            comment => 'Tuomas Starck',
            groups  => ['adm', 'crontab', 'sudo', 'syslog'],
            super   => true;
        'fiddler':
            comment => 'Jussi Kaijalainen',
            groups  => ['syslog'],
            super   => true;
    }

    file { '/etc/sudoers':
        ensure => present,
        mode   => 0440,
        owner  => 'root',
        group  => 'root',
        source => 'puppet:///modules/common/sudoers';
    }

    class {
        'common::tuomas': require => User['tuomas'];
    }
}
