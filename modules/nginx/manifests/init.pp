/* Module: nginx
 *
 * 2015-08-23 / Meetin.gs
 */
class nginx() {
    package {
        'nginx-light': ensure => installed
    }

    file {
        '/etc/nginx/nginx.conf':
            mode    => 0644,
            content => template('nginx/nginx.conf.erb'),
            notify  => Service['nginx'];
        '/etc/nginx/sites-available':
            ensure  => directory,
            recurse => true,
            purge   => true,
            source  => 'puppet:///modules/nginx/sites';
        '/etc/nginx/sites-enabled/default':
            ensure  => absent;
    }

    service { 'nginx':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        require    => Package['nginx-light'];
    }
}
