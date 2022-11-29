/* Class: sshd
 *
 * SSH server configuration suitable
 * for local development machine.
 *
 * 2014-02-21 / Meetin.gs
 */
class localdev::sshd() {
    augeas { 'sshd_config':
        context => '/files/etc/ssh/sshd_config',
        changes => [
            'set LogLevel ERROR',
            'set LoginGraceTime 30',
            'set PasswordAuthentication no',
            'set PermitEmptyPasswords no',
            'set PermitRootLogin no',
            'set X11Forwarding no',
            'set UseDNS no'
        ];
    }
}
