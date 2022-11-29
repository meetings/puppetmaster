/* Module: logging
 *
 * Configure log data to flow to central logging servers.
 *
 * 2015-05-06 / Meetin.gs
 */
class logging() {
    class {
        'logging::kludge':;
        'logging::rotate':;
    }

    file {
        '/etc/rsyslog.conf':
            mode   => 0644,
            source => 'puppet:///modules/logging/rsyslog.conf';
        '/etc/rsyslog.d/50-default.conf':
            mode   => 0644,
            source => 'puppet:///modules/logging/50-default.conf';
    }

    /* Input file module configuration. These should
     * be realized on relevant log source hosts.
     */
    @file {
        '/etc/rsyslog.d/00-file-input.conf':
            mode   => 0644,
            source => 'puppet:///modules/logging/00-file-input.conf',
            tag    => ['log_apache', 'log_nginx'];
        '/etc/rsyslog.d/05-apache.conf':
            mode   => 0644,
            source => 'puppet:///modules/logging/05-apache.conf',
            tag    => 'log_apache';
        '/etc/rsyslog.d/05-nginx.conf':
            mode   => 0644,
            source => 'puppet:///modules/logging/05-nginx.conf',
            tag    => 'log_nginx';
    }

    /* Incoming log data configuration, which ought
     * to be realized on central log servers.
     */
    @file {
        '/etc/rsyslog.d/10-server.conf':
            mode   => 0644,
            source => 'puppet:///modules/logging/10-server.conf',
            tag    => 'log_server';
        '/etc/rsyslog.d/70-nginx.conf':
            mode   => 0644,
            source => 'puppet:///modules/logging/70-nginx.conf',
            tag    => 'log_server';
    }

    /* Log relay configuration, which ought to be
     * realized on dom0s.
     */
    @file {
        '/etc/rsyslog.d/10-relay.conf':
            mode   => 0644,
            source => 'puppet:///modules/logging/10-relay.conf',
            tag    => 'log_relay';
    }

    /* Log slave configuration, which ought to be realized
     * on all domUs except not on the central log servers.
     */
    @file {
        '/etc/rsyslog.d/10-slave.conf':
            mode   => 0644,
            source => 'puppet:///modules/logging/10-slave.conf',
            tag    => 'log_slave';
    }
}
