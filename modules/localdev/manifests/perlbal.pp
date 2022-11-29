/* Class: perlbal
 *
 * 2014-04-16 / Meetin.gs
 */
class localdev::perlbal() {
    file {
        '/etc/cron.d/perlbal_delayed_start':
            mode   => 0644,
            source => "puppet:///modules/localdev/perlbal_delayed_start";

        '/usr/local/bin/run_perlbal.sh':
            mode   => 0755,
            source => 'puppet:///modules/localdev/run_perlbal.sh';
    }
}
