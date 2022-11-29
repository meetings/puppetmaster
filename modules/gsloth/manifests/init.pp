/* Module: gsloth
 *
 * 2017-08-21 / Meetin.gs
 */
class gsloth($config) {
    package {
        ['sqlite3']: ensure => installed
    }

    file {
        '/etc/default/gearsloth':
            mode    => 0644,
            source  => 'puppet:///modules/gsloth/default';

        '/etc/gearsloth':
            ensure  => 'directory';

        '/var/lib/gearsloth':
            ensure  => 'directory';

        '/etc/gearsloth/gearsloth.json':
            mode    => 0644,
            source  => "puppet:///modules/gsloth/${config}.json";
    }
}
