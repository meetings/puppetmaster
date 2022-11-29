/* Module: varnish
 *
 * Install and configure Varnish http accelerator.
 *
 * 2014-01-11 / Meetin.gs
 */
class varnish($flavor) {
    /* Install packages. UUID tool is needed to generate
     * authorization token for management interface.
     */
    package {
        ['varnish', 'uuid-runtime']: ensure => installed
    }

    file {
        '/etc/default/varnish':
            mode    => 0644,
            source  => "puppet:///modules/varnish/default_${flavor}",
            require => Package['varnish'];

        '/etc/varnish/default.vcl':
            mode    => 0644,
            source  => "puppet:///modules/varnish/vcl_${flavor}",
            require => Package['varnish'];
    }

    exec {
        'generate_secret':
            command     => '/usr/bin/uuidgen > /etc/varnish/secret',
            creates     => '/etc/varnish/secret',
            require     => Package['uuid-runtime'],
            notify      => Exec['hide_secret'];

        'hide_secret':
            command     => '/bin/chmod 400 /etc/varnish/secret',
            refreshonly => true;
    }

    service { 'varnish':
        enable    => true,
        ensure    => running,
        subscribe => File[
            '/etc/default/varnish',
            '/etc/varnish/default.vcl'
        ];
    }
}
