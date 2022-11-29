/* Class: blog
 *
 * Set up simple Apache configuration for Wordpress blog.
 *
 * 2014-09-24 / Meetin.gs
 */
class sites::blog() {
    $packages = [
        'apache2',
        'php7.0',
        'libapache2-mod-php7.0',
        'php7.0-mysql',
        'php7.0-curl',
        'php7.0-mbstring',
        'php7.0-gd',
        'php7.0-xml',
        'php7.0-xmlrpc',
        'php7.0-intl',
        'php7.0-soap',
        'php7.0-zip'
    ]

    package {
        $packages: ensure => installed
    }

    realize Package['mysql-client']

    file {
        '/etc/apache2/httpd.conf':
            mode    => 0644,
            source  => 'puppet:///modules/sites/httpd.conf',
            require => Package['apache2'];
        '/etc/apache2/ports.conf':
            mode    => 0644,
            source  => 'puppet:///modules/sites/ports.conf',
            require => Package['apache2'];
        '/etc/apache2/sites-available/000-default.conf':
            mode    => 0644,
            source  => 'puppet:///modules/sites/blog_default',
            require => Package['apache2'];
        '/etc/apache2/mods-enabled/rewrite.load':
            ensure => 'link',
            target => '../mods-available/rewrite.load',
            require => Package['apache2'];
        '/usr/local/sbin/meetings_sync_var_www.sh':
            mode    => 0755,
            source  => 'puppet:///modules/sites/meetings_sync_var_www.sh';
    }


define set_php_var($value) {
  exec { "sed -i 's/^;*[[:space:]]*$name[[:space:]]*=.*$/$name = $value/g' /etc/php/7.0/apache2/php.ini":
    unless  => "grep -xqe '$name[[:space:]]*=[[:space:]]*$value' -- /etc/php/7.0/apache2/php.ini",
    path    => "/bin:/usr/bin",
    require => Package['libapache2-mod-php7.0'],
    notify  => Service[apache2];
  }
}

set_php_var {
  "post_max_size":       value => '256M';
  "upload_max_filesize": value => '256M';
  "memory_limit":        value => '256M';
  "short_open_tag":      value => 'On';
}

/* these are not working, but i don't know if they should be anymore either as we have a newer apache.. */

    Augeas { require => Package['libapache2-mod-php7.0'] }
    augeas {
        'start_servers':
            context => "/files/etc/apache2/apache2.conf/*[arg = 'mpm_prefork_module']/directive[. = 'StartServers']",
            changes => 'set arg "15"';
        'min_spare_servers':
            context => "/files/etc/apache2/apache2.conf/*[arg = 'mpm_prefork_module']/directive[. = 'MinSpareServers']",
            changes => 'set arg "15"';
        'max_spare_servers':
            context => "/files/etc/apache2/apache2.conf/*[arg = 'mpm_prefork_module']/directive[. = 'MaxSpareServers']",
            changes => 'set arg "45"';
        'max_clients':
            context => "/files/etc/apache2/apache2.conf/*[arg = 'mpm_prefork_module']/directive[. = 'MaxClients']",
            changes => 'set arg "45"';
        'max_requests_per_child':
            context => "/files/etc/apache2/apache2.conf/*[arg = 'mpm_prefork_module']/directive[. = 'MaxRequestsPerChild']",
            changes => 'set arg "999"';
    }

    service { 'apache2':
        enable    => true,
        ensure    => running,
        subscribe => File[
            '/etc/apache2/httpd.conf',
            '/etc/apache2/ports.conf',
            '/etc/apache2/sites-available/000-default.conf'
        ];
    }
}
