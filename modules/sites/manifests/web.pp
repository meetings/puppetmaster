/* Class: web
 *
 * Set up Lighty for misc websites.
 *
 * Large parts of the configuration is in the Github:meetings/websites
 * repository. This only sets up a basic lighttpd with logging.
 *
 * 2014-03-26 / Meetin.gs
 */
class sites::web() {
    package {
        ['lighttpd', 'php5-cgi']: ensure => installed
    }

    file { '/var/log/lighty':
        ensure  => 'directory',
        mode    => 0644,
        owner   => 'syslog',
        group   => 'adm';
    }

    file { '/etc/lighttpd/lighttpd.conf':
        mode    => 0644,
        source  => 'puppet:///modules/sites/lighttpd.conf',
        require => Package['lighttpd'];
    }

    file { '/etc/lighttpd/conf-enabled/10-cgi.conf':
        ensure => 'link',
        target => '/etc/lighttpd/conf-available/10-cgi.conf',
        require => Package['lighttpd'];
    }

    file { '/etc/lighttpd/conf-enabled/10-fastcgi.conf':
        ensure => 'link',
        target => '/etc/lighttpd/conf-available/10-fastcgi.conf',
        require => Package['lighttpd'];
    }

    file { '/etc/lighttpd/conf-enabled/15-fastcgi-php.conf':
        ensure => 'link',
        target => '/etc/lighttpd/conf-available/15-fastcgi-php.conf',
        require => Package['lighttpd'];
    }

    service { 'lighttpd':
        enable  => true,
        ensure  => running,
        require => Package['lighttpd'];
    }
}
