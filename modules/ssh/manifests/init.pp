/* Module: ssh
 *
 * SSH module manages ssh service,
 * authentication and portforwarding.
 *
 * 2014-05-12 / Meetin.gs
 */
class ssh() {
    class { 'ssh::sshd': }
    class { 'ssh::kludge': }
    class { 'ssh::portforward': }
}
