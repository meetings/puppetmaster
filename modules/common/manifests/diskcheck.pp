/* Class: diskcheck
 *
 * First send mail and then sms if disk starts to get full.
 *
 * 2014-02-08 / Meetin.gs
 */
class common::diskcheck() {
    file {
        '/usr/local/bin/diskspace_quarter_left.sh':
            mode   => 0755,
            source => 'puppet:///modules/common/diskspace_quarter_left.sh';
        '/usr/local/bin/diskspace_tenth_left.sh':
            mode   => 0755,
            source => 'puppet:///modules/common/diskspace_tenth_left.sh';
    }

    cron {
        'diskspacecheck':
            ensure => absent;

        'diskgettinglow':
            minute   => '55',
            hour     => '*',
            monthday => '*',
            month    => '*',
            weekday  => '*',
            user     => 'root',
            command  => '/usr/local/bin/diskspace_quarter_left.sh';

        'diskreallylow':
            minute   => '57',
            hour     => '*',
            monthday => '*',
            month    => '*',
            weekday  => '*',
            user     => 'root',
            command  => '/usr/local/bin/wrap diskspace_tenth_left.sh "disk space running out"';
    }
}
