/* Class: clean
 *
 * Remove fossilized and stale objects.
 *
 * 2015-07-30 / Meetin.gs
 */
class common::clean() {
    file {
        /* There are no optical drives.
         */
        '/media/cdrom':
            ensure  => absent,
            force   => true;

        /* Lighty logs should go to /var/log/lighty and
         * this should be useless default directory.
         */
        '/etc/logrotate.d/lighttpd':
            ensure  => absent;
        '/var/log/lighttpd':
            ensure  => absent,
            recurse => true,
            force   => true;

        /* Deprecated files.
         */
        '/etc/cron.weekly/ntpdate':
            ensure  => absent;
    }
}
