/* Class: lighty
 *
 * Install and set up Lighty with FastCGI for DCP.
 *
 * 2014-08-02 / Meetin.gs
 */
class miner::lighty() {
    class { 'lighty::common':
        config => 'puppet:///modules/miner/lighttpd.conf'
    }

    package {
        ['php5-cgi', 'php5-mysql', 'php5-curl']: ensure => installed
    }

    file {
        '/usr/local/dcp/html':
            ensure  => directory,
            mode    => 0755,
            owner   => 'www-data',
            group   => 'www-data',
            require => Package['lighttpd'],
            before  => File['/etc/lighttpd/lighttpd.conf'];

        '/var/www/query.jsonp.php':
            mode   => 0644,
            source => 'puppet:///modules/miner/query.jsonp.php';
    }
}
