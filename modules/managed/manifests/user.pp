/* Class: user
 *
 * 2014-04-23 / Meetin.gs
 */
class managed::user() {
    common::adduser {
        'manager': comment => 'Integration manager';
    }

    file { "/etc/sudoers.d/manager":
        mode   => 0440,
        owner  => 'root',
        group  => 'root',
        source => 'puppet:///modules/managed/manager';
    }
}
