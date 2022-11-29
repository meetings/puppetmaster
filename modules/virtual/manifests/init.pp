/* Module: virtual
 *
 * Define a global set of virtual resources.
 *
 * 2014-08-05 / Meetin.gs
 */
class virtual() {
    @package {
        'mysql-client': ensure => installed
    }

    @file { '/root/.ssh':
        ensure => directory,
        mode   => 0700,
        tag    => 'root_ssh_directory';
    }

    @file { '/etc/cron.d/api_restart':
        mode    => 0644,
        content => template('virtual/api_restart.erb'),
        tag     => 'api_restart';
    }
}
