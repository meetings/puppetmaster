/* Class: puppet
 *
 * 2015-05-11 / Meetin.gs
 */
class common::puppet() {
    tag 'bootstrap'

    file {
        '/etc/puppet/puppet.conf':
            mode   => 0644,
            source => 'puppet:///modules/common/puppet.conf';
        '/etc/cron.hourly/disable_puppet':
            mode   => 0755,
            source => 'puppet:///modules/common/disable_puppet.sh';
    }
}
