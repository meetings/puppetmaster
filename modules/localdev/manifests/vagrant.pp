/* Class: vagrant
 *
 * 2014-02-21 / Meetin.gs
 */
class localdev::vagrant() {
    user { 'vagrant':
        ensure     => present,
        comment    => 'Vagrant',
        gid        => 'vagrant',
        groups     => ['adm', 'sudo', 'syslog'],
        membership => inclusive,
        home       => '/home/vagrant',
        managehome => true,
        shell      => '/bin/bash';
    }

    file {
        '/home/vagrant/.ssh':
            ensure => directory,
            mode   => 0700,
            owner  => 'vagrant',
            group  => 'vagrant';

        '/home/vagrant/.ssh/authorized_keys':
            owner  => 'vagrant',
            group  => 'vagrant',
            source => 'puppet:///modules/localdev/id_vagrant.pub';

        '/etc/sudoers':
            mode   => 0440,
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/localdev/sudoers';
    }
}
