/* Class: vagrant
 *
 * 2014-01-14 / Meetin.gs
 */
class network::vagrant() {
    file { '/etc/network/interfaces':
        mode   => 0644,
        source => 'puppet:///modules/network/interfaces.vagrant';
    }
}
