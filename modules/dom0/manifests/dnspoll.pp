/* Class: dnspoll
 *
 * 2014-09-09 / Meetin.gs
 */
class dom0::dnspoll() {
    file {
        '/usr/local/bin/dnspoll.sh':
            mode   => 0755,
            source => 'puppet:///modules/dom0/dnspoll.sh';
        '/etc/cron.d/dnspoll':
            mode   => 0644,
            source => 'puppet:///modules/dom0/dnspoll.cron';
    }
}
