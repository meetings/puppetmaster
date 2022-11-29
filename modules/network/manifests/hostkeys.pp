/* Class: hostkeys
 *
 * 2014-02-17 / Meetin.gs
 */
class network::hostkeys($flavor='default') {
    file { '/etc/ssh/ssh_known_hosts':
        mode   => 0644,
        source => "puppet:///modules/network/known_hosts_${flavor}";
    }
}
