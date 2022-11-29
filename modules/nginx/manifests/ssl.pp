/* Class: ssl
 *
 * 2015-08-23 / Meetin.gs
 */
class nginx::ssl() {
    $meetings = '/etc/ssl/private/meetings.pem'
    $dicole   = '/etc/ssl/private/dicolenet.pem'
    $thelang  = '/etc/ssl/private/thelanguagepointcom.pem'

    common::addsecret {
        'meetings.pem':
            path   => $meetings,
            notify => File[$meetings];

        'dicolenet.pem':
            path   => $dicole,
            notify => File[$dicole];

        'thelanguagepointcom.pem':
            path   => $thelang,
            notify => File[$thelang];
    }

    file {
        [$meetings, $dicole, $thelang]:
            mode => 0400;

        '/etc/nginx/conf.d/ssl.conf':
            mode    => 0644,
            source  => 'puppet:///modules/nginx/ssl.conf',
            require => Package['nginx-light'],
            notify  => Service['nginx'];
    }
}
