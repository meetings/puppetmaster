/* Module: dom0
 *
 * This module manages machines on bare metal at Hetzners datacenters.
 *
 * More precisely, Xen, dhcpd and dnsmasq are installed, some bugs are
 * fixed and virtual machine creation is configured.
 *
 * 2015-01-28 / Meetin.gs
 */
class dom0($dom0_mem='2048') {
    stage { 'pre': }
    stage { 'post': }
    Stage['pre'] -> Stage['main'] -> Stage['post']

    /* Include configuration to relay logs to central log servers.
     */
    File <| tag == 'log_relay' |>

    class {
        /* Try to add relevant users early, because The Keeper of
         * Secrets it is needed when setting up Postfix.
         */
        'dom0::users': stage => pre;
        'dom0::dnspoll':;
        'dom0::sshd':;
        'dom0::xen': dom0_mem => $dom0_mem;
    }

    file {
        /* On dom0s, whereami is just a symlink to hostname(1).
         */
        '/bin/whereami':
            ensure => link,
            target => '/bin/hostname';

        /* Last stage init script, which configures physical network
         * interface and initializes firewall and port butterfly.
         */
        '/etc/rc.local':
            mode   => 0755,
            source => 'puppet:///modules/dom0/rc.local';

        /* Make a bunch of administrative scripts available.
         */
        '/usr/local/sbin':
            ensure  => directory,
            recurse => true,
            source  => 'puppet:///modules/dom0/admin';
    }
}
