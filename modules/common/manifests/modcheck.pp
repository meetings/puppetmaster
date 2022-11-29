/* Class: modcheck
 *
 * Check that the domU has modules for the current kernel.
 *
 * 2013-05-21 / Meetin.gs
 */
class common::modcheck() {
    file { '/etc/cron.daily/modcheck':
        /* NOTE! Change to present to activate the check */
        ensure => absent,
        mode   => 0755,
        source => 'puppet:///modules/common/modcheck';
    }
}
