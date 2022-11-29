/* Define: addppa
 *
 * Set up any given PPA.
 *
 * 2013-05-22 / Meetin.gs
 */
define common::addppa($ppa=$title, $file, $key) {
    file { "/etc/apt/sources.list.d/${file}":
        mode   => 0644,
        source => "puppet:///modules/common/ppa/${file}",
        notify => Exec["${ppa}"];
    }

    exec { "${ppa}":
        command     => "apt-key adv --keyserver keyserver.ubuntu.com --recv-key ${key}",
        path        => ['/bin', '/usr/bin'],
        unless      => "apt-key list | grep -q ${key}",
        refreshonly => true;
    }
}
