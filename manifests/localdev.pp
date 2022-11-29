/*\ localdev.pp
 *  Puppet manifest for the local development machinae.
\*/

File <| tag == 'localdev' |>
File <| tag == 'meetings_workers' |>

stage { 'before':; 'after':; }
Stage['before'] -> Stage['main'] -> Stage['after']

class {
    'common::apt':        stage => before, flavor => 'default';
    'common::repository': stage => before;

    'common::clean':;
    'common::deployer':;
    'common::puppet':;
    'common::timezone':;
    'common::update':;

    'localdev::ca':;
    'localdev::deployer':;
    'localdev::perlbal':;
    'localdev::postfix':;
    'localdev::sshd':;
    'localdev::vagrant':;

    'network::vagrant':;
    'network::hostkeys':  flavor => 'localdev';

    'logging':;
    'mysql':;
    'nodejs':;
    'virtual':;

    'dcp':                flavor   => 'dev';
    'dcp::lighty':        flavor   => 'dev';
    'gearman':            devmode  => true;
    'perlbal':            flavor   => 'dev';
    'mogile':             trackers => '127.0.0.1:7001';

    'localdev::packages': stage => after;
}
