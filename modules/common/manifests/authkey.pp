/* Define: authkey
 *
 * Allow user to log in by authorizing
 * associated public key.
 *
 * 2013-03-10 / Meetin.gs
 */
define common::authkey($user=$title) {
    file {
        "/home/${user}/.ssh":
            ensure => directory,
            mode   => 0700,
            owner  => "${user}",
            group  => 'users';
        "/home/${user}/.ssh/authorized_keys":
            ensure => present,
            mode   => 0644,
            owner  => "${user}",
            group  => 'users',
            source => "puppet:///modules/common/authorized_keys/${user}.pub";
    }
}
