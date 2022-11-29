/* Module: munin
 *
 * 2013-02-13 / Meetin.gs
 */
class munin() {
    file {
        /* PPA install script.
         */
        '/usr/local/sbin/munin-ppa.sh':
            mode    => 0755,
            source  => 'puppet:///modules/munin/munin-ppa.sh';
    }

    /* Add Munin PPA.
     */
    exec { '/usr/local/sbin/munin-ppa.sh':
        path    => ['/bin', '/usr/bin'],
        require => File['/usr/local/sbin/munin-ppa.sh'];
    }

    /*
     */
    package { 'munin':
        ensure  => latest,
        require => Exec['/usr/local/sbin/munin-ppa.sh'];
    }
}
