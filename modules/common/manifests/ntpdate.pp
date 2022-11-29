/* Class: ntpdate
 *
 * When domUs run stable and long, their clock may deviate
 * considerably. This class sets up a cron job, which run
 * ntpdate(8) against the underlying dom0.
 *
 * 2015-07-30 / Meetin.gs
 */
class common::ntpdate() {
    file { '/etc/cron.daily/ntpdate':
        mode   => 0755,
        source => 'puppet:///modules/common/ntpdate';
    }
}
