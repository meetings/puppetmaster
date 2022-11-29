/* Class: apt
 *
 * 2015-09-15 / Meetin.gs
 */
class common::apt($unattended_upgrades=true) {
    tag 'bootstrap'

    file {
        '/etc/apt/sources.list':
            mode    => 0644,
            content => template('common/sources.list.erb');
        '/etc/apt/apt.conf.d/02periodic':
            mode    => 0644,
            content => template('common/02periodic.erb');
        '/etc/apt/apt.conf.d/99translations':
            mode    => 0644,
            source  => 'puppet:///modules/common/99translations';
    }
}
