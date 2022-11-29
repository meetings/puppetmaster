/* Class: crypt
 *
 * 2014-12-18 / Meetin.gs
 */
class dom0::crypt() {
    package {
        'cryptsetup': ensure => installed
    }

    augeas { 'cryptdisks':
        context => '/files/etc/default/cryptdisks',
        changes => 'set CRYPTDISKS_ENABLE "no"',
        require => Package['cryptsetup'];
    }
}
