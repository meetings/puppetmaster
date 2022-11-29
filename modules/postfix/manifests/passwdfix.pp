/* Class: passwdfix
 *
 * 2014-03-03 / Meetin.gs
 */
class postfix::passwdfix() {
    /* On initial puppet run, common::addsecret tends to fail
     * and leaves an empty file behind. This should reset the
     * situation so that puppet can try again.
     */
    exec { 'passwdfix':
        command     => 'rm /etc/postfix/passwd.asc',
        unless      => 'test -s /etc/postfix/passwd',
        returns     => [0, 1],
        path        => ['/bin', '/usr/bin'];
    }
}
