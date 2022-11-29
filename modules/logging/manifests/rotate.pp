/* Class: rotate
 *
 * Rotate all the logs.
 *
 * 2015-03-20 / Meetin.gs
 */
class logging::rotate() {
    file {
        '/etc/logrotate.conf':
            mode   => 0644,
            source => 'puppet:///modules/logging/logrotate.conf';

        '/etc/logrotate.d':
            ensure  => directory,
            recurse => true,
            replace => true,
            purge   => false,
            source  => 'puppet:///modules/logging/rotate';
    }
}
