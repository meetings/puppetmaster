/* Class: kludge
 *
 * It seems rsyslog fails to create new logfiles as it should.
 * Therefore this class kludges empty files to /var/log so that
 * rsyslog succeeds to log.
 *
 * 2015-05-06 / Meetin.gs
 */
class logging::kludge() {
    file {
        ['/var/log/alert.log',
         '/var/log/api.log',
         '/var/log/cuty.log',
         '/var/log/local.log',
         '/var/log/nag.log',
         '/var/log/paint.log',
         '/var/log/pollbal.log',
         '/var/log/sloth.log',
         '/var/log/stats.log',
         '/var/log/worker.log']:
            mode    => 0640,
            owner   => 'syslog',
            group   => 'adm',
            content => '',
            replace => false;
    }
}
