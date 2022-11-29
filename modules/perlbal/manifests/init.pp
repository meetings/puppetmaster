/* Module: perlbal
 *
 * 2015-04-20 / Meetin.gs
 */
class perlbal($flavor) {
    package {
        'perlbal':
            ensure  => installed;

        'libnet-netmask-perl':
            ensure  => installed;

        'libperlbal-plugin-extredirector-perl':
            ensure  => installed,
            require => Package['perlbal'];
    }

    file {
        /* Init script in package is broken, use this fixed version.
         */
        '/etc/init.d/perlbal':
            mode    => 0755,
            source  => 'puppet:///modules/perlbal/init',
            require => Package['perlbal'];

        '/etc/default/perlbal':
            mode    => 0644,
            source  => 'puppet:///modules/perlbal/default',
            require => Package['perlbal'];
        '/etc/perlbal/perlbal.conf':
            mode    => 0644,
            source  => "puppet:///modules/perlbal/_${flavor}/perlbal.conf",
            require => Package['perlbal'];

        '/etc/perlbal/redirect.pl':
            mode    => 0755,
            source  => "puppet:///modules/perlbal/_${flavor}/redirect.pl",
            before  => File['/etc/perlbal/perlbal.conf'],
            require => Package['perlbal'];
        '/etc/perlbal/redirect.rules':
            mode    => 0644,
            source  => "puppet:///modules/perlbal/_${flavor}/redirect.rules",
            before  => File['/etc/perlbal/perlbal.conf'],
            require => Package['perlbal'];
        '/var/log/perlbal':
            ensure  => directory,
            before  => File['/etc/perlbal/perlbal.conf'];

        /* Create pool directory and copy initial pool files,
         * but do not overwrite them if pollbal should work.
         */
        '/run/pool':
            ensure  => directory,
            recurse => true,
            replace => false,
            owner   => 'nobody',
            group   => 'nogroup',
            source  => "puppet:///modules/perlbal/_${flavor}/pool",
            before  => File['/etc/perlbal/perlbal.conf'];

        /* Drop Upstart script to save pool files at shutdown
         * and restore at startup.
         */
        '/etc/init/pool-save-and-restore.conf':
            mode    => 0644,
            source  => 'puppet:///modules/perlbal/pool-save-and-restore.conf';

        '/etc/cron.d/meetings_switcher':
            mode    => 0644,
            source  => 'puppet:///modules/perlbal/meetings_switcher';
        '/usr/local/sbin/dp':
            mode    => 0755,
            source  => 'puppet:///modules/perlbal/dp';
        '/root/dp':
            ensure  => link,
            target  => '/usr/local/sbin/dp',
            require => File['/usr/local/sbin/dp'];
    }

    service { 'perlbal':
        enable    => true,
        ensure    => running,
        subscribe => File[
            '/etc/perlbal/perlbal.conf',
            '/etc/perlbal/redirect.rules'
        ];
    }
}
