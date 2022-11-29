/* Module: network
 *
 * 2014-01-11 / Meetin.gs
 */
class network() {
    /* Hosts file must be tweaked a little, especially on domUs,
     * in order to have hostname resolving correctly.
     */
    file { '/etc/hosts':
        mode    => 0644,
        content => template('network/hosts.erb');
    }
}
