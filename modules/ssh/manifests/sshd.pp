/* Class: sshd
 *
 * Manage ssh server service and configuration.
 *
 * 2015-01-28 / Meetin.gs
 */
class ssh::sshd() {
    tag 'bootstrap'

    augeas { 'sshd_config':
        context => '/files/etc/ssh/sshd_config',
        changes => [
            'set MaxAuthTries 3',
            'set LogLevel INFO',
            'set X11Forwarding no',
            'set UseDNS no',
            'set Ciphers/1 chacha20-poly1305@openssh.com',
            'set Ciphers/2 aes128-ctr',
            'set Ciphers/3 aes192-ctr',
            'set Ciphers/4 aes256-ctr',
            'set Ciphers/5 aes128-gcm@openssh.com',
            'set Ciphers/6 aes256-gcm@openssh.com',
            'set Ciphers/7 arcfour',
            'set Ciphers/8 arcfour256',
            'set Ciphers/9 arcfour128',
            'set GatewayPorts clientspecified'
        ],
        notify => Service['ssh'];
    }

    service { 'ssh':
        enable => true,
        ensure => running;
    }
}
