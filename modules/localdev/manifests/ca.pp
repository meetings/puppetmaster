/* Class: ca
 *
 * 2014-03-06 / Meetin.gs
 */
class localdev::ca() {
    file { '/usr/local/share/ca-certificates/mtngs.crt':
        mode   => 0644,
        source => 'puppet:///modules/localdev/mtngs.crt',
        notify => Exec['updateca'];
    }

    exec { 'updateca':
        command     => 'update-ca-certificates',
        path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        refreshonly => true;
    }
}
