/* Class: sshd
 *
 * 2015-01-28 / Meetin.gs
 */
class dom0::sshd() {
    tag 'bootstrap'

    /* Make sshd(8) listen to 22, 443 and 11122.
     */
    ssh::openport {
        '22':    notify => Service['ssh'];
        '443':   notify => Service['ssh'];
        '11122': notify => Service['ssh'];
    }
}
