/* Class: elk
 *
 * 2015-04-08 / Meetin.gs
 *
 * FIXME!
 *   None of this will work now or next time this is needed.
 *   Logstash or Elasticsearch are not in the repository,
 *   and Kibana has changed completely. If elk needs to be
 *   recreated, this class must be thoroughly revised.
 */
class logging::elk() {
    $packages = [
        'kibana',
        'logstash',
        'openjdk-7-jre',
        'elasticsearch'
    ]

    package {
        $packages: ensure => installed
    }

    file {
        '/etc/logstash/conf.d/input.conf':
            mode    => 0644,
            source  => 'puppet:///modules/logging/logstash/input.conf',
            require => Package['logstash'];
        '/etc/logstash/conf.d/filter.conf':
            mode    => 0644,
            source  => 'puppet:///modules/logging/logstash/filter.conf',
            require => Package['logstash'];
        '/etc/logstash/conf.d/output.conf':
            mode    => 0644,
            source  => 'puppet:///modules/logging/logstash/output.conf',
            require => Package['logstash'];
    }

    exec { 'enable-elastic':
        command     => 'update-rc.d elasticsearch defaults',
        path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        subscribe   => Package['elasticsearch'],
        refreshonly => true;
    }
}
