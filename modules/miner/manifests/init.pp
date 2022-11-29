/* Module: miner
 *
 * 2015-05-08 / Meetin.gs
 */
class miner() {
    class { 'miner::users': }
    class { 'miner::lighty': }

    common::addsecret {
        'stat': path => '/root/.ssh/stat';
    }

    file {
        '/root/.ssh/config_stat':
            mode   => 0644,
            source => 'puppet:///modules/miner/config_stat';
        '/root/.ssh/stat.pub':
            mode   => 0644,
            source => 'puppet:///modules/common/authorized_keys/stat.pub';

        '/etc/cron.d/import_and_crunch_database':
            mode   => 0644,
            source => 'puppet:///modules/miner/import_and_crunch_database';
    }
}
