/* Class: queuewatch
 *
 * Watch mail queue and report if it gets stuck.
 *
 * 2013-07-15 / Meetin.gs
 */
class postfix::queuewatch() {
    file { '/usr/local/sbin/queuewatch.sh':
        mode    => 0755,
        source  => 'puppet:///modules/postfix/queuewatch.sh';
    }

    cron { 'queuewatch':
        minute   => '42',
        hour     => '*',
        monthday => '*',
        month    => '*',
        weekday  => '*',
        user     => 'root',
        command  => '/usr/local/sbin/queuewatch.sh',
        require  => File['/usr/local/sbin/queuewatch.sh'];
    }
}
