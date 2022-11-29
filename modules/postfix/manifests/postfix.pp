/* Class: postfix
 *
 * 2014-10-27 / Meetin.gs
 */
class postfix::postfix() {
    package {
        ['postfix', 'mailutils']: ensure => installed
    }

    common::addsecret { 'passwd':
        path    => '/etc/postfix/passwd',
        require => Package['postfix'],
        notify  => Exec['dopasswddb'];
    }

    file {
        '/etc/aliases':
            mode    => 0644,
            source  => 'puppet:///modules/postfix/aliases';
        '/etc/mailname':
            mode    => 0644,
            source  => 'puppet:///modules/postfix/mailname';
        '/etc/postfix/main.cf':
            mode    => 0644,
            source  => 'puppet:///modules/postfix/main.cf',
            require => Package['postfix'];

        ['/etc/postfix/passwd', '/etc/postfix/passwd.db']:
            mode        => 0600;
    }

    /* Postfix wants to have settings in Berkeley databases, so
     * we need to run db creation commands whenever configurations
     * change.
     */
    exec { 'dopasswddb':
        command     => 'postmap /etc/postfix/passwd',
        onlyif      => 'test -f /etc/postfix/passwd',
        path        => ['/usr/bin', '/usr/sbin'],
        refreshonly => true,
        notify      => File[
            '/etc/postfix/passwd',
            '/etc/postfix/passwd.db'
        ];
    }
}
