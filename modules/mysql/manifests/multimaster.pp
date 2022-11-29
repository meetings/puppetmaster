/* Class: multimaster
 *
 * Multi-master mysql setup with active/passive switch.
 *
 * 2015-09-19 / Meetin.gs
 */
class mysql::multimaster(
    $server_id=undef,
    $auto_increment=undef,
    $inc_offset=undef,
    $binlog_expire=7,
    $slave_check_min=undef
) {
    class { 'mysql::common': }

    file {
        /* Template uses:
         *  $server_id
         *  $auto_increment
         *  $inc_offset
         *  $binlog_expire
         */
        '/etc/mysql/conf.d/multi-master.cnf':
            mode    => 0644,
            content => template('mysql/multi-master.cnf.erb'),
            require => Package['mysql-server'];

        '/usr/local/bin/meetings_pb_role_select.sh':
            mode    => 0755,
            source  => 'puppet:///modules/mysql/meetings_pb_role_select.sh';

        '/usr/local/bin/check_slave_status.sh':
            mode    => 0755,
            source  => 'puppet:///modules/mysql/check_slave_status.sh';
    }

    /* Spam like there's no tomorrow, if replication
     * slave doesn't work. Except nothing is done if
     * $slave_check_min is not defined.
     */
    if $slave_check_min {
        cron { 'slavecheck':
            minute   => "${slave_check_min}",
            hour     => '*',
            monthday => '*',
            month    => '*',
            weekday  => '*',
            user     => 'root',
            command  => '/usr/local/bin/wrap check_slave_status.sh "replication error"';
        }
    }
}
