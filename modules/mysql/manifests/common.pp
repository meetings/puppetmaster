/* Class: common
 *
 * Configure common MySQL server properties.
 *
 * 2014-04-10 / Meetin.gs
 */
class mysql::common() {
    package {
        'mysql-server': ensure => installed
    }

    file { '/etc/mysql/my.cnf':
        mode    => 0644,
        source  => 'puppet:///modules/mysql/my.cnf',
        require => Package['mysql-server'];
    }

    service { 'mysql':
        enable    => true,
        ensure    => running,
        subscribe => File['/etc/mysql/my.cnf'];
    }
}
