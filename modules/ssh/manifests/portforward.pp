/* Class: portforward
 *
 * Copy and run the portforward scripts.
 *
 * 2014-02-08 / Meetin.gs
 */
class ssh::portforward() {
    tag 'bootstrap'

    file {
        '/root/id_pf':
            mode   => 0400,
            source => 'puppet:///modules/ssh/id_pf';

        '/usr/local/pf':
            ensure  => directory,
            recurse => true,
            source  => 'puppet:///modules/ssh/pf';
    }

    cron { 'ensure':
        minute   => '*',
        hour     => '*',
        monthday => '*',
        month    => '*',
        weekday  => '*',
        user     => 'root',
        command  => '/usr/local/pf/ensure_my_connections.pl';
    }
}
