/* Class: deployer
 *
 * Install Meetin.gs Deployer's identity
 * and configure a host alias for Github.
 *
 * 2014-02-22 / Meetin.gs
 */
class localdev::deployer() {
    file {
        '/home/vagrant/.ssh/config':
            mode    => 0644,
            source  => 'puppet:///modules/common/deployer_config';
        '/home/vagrant/.ssh/deployer':
            mode    => 0600,
            source  => 'puppet:///modules/common/deployer';
        '/home/vagrant/.ssh/deployer.pub':
            mode    => 0644,
            source  => 'puppet:///modules/common/deployer.pub';
    }
}
