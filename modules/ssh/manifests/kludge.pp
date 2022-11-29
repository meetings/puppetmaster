/* Class: kludge
 *
 * 2014-05-12 / Meetin.gs
 */
class ssh::kludge() {
    /* Fix missing file bug:
     * https://bugs.launchpad.net/ubuntu/+source/pam/+bug/155794
     *
     * This is one of silly kludges, which exists to circumvent a
     * known longstanding bug. Without this, auth.log is flooded
     * with errors each time portforward script is run.
     */
    exec { 'update-locale':
        creates => '/etc/default/locale',
        path    => ['/usr/bin', '/usr/sbin'];
    }

    /* Fix could not load key bug:
     * https://bugs.launchpad.net/ubuntu/+source/openssh/+bug/1005440
     *
     * Again, a kludge. Again, without this, auth.log if flooded. The
     * key is not actually used.
     */
    exec { 'ssh-keygen -t ecdsa -N "" -f /etc/ssh/ssh_host_ecdsa_key':
        creates => '/etc/ssh/ssh_host_ecdsa_key',
        path    => ['/usr/bin', '/usr/sbin'];
    }
}
