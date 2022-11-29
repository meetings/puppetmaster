# Vagrantfile for a roaming Puppetmaster
# vi: set sw=2 ts=2 sts=2 ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  ### Machine settings
  #
  config.vm.hostname = "puppet"
  config.vm.box      = "trusty-2015-01-01"
  config.vm.box_url  = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  ### Provisioning
  #
  config.vm.provision :shell, path: ".vagrant/stdintty.sh"
  config.vm.provision :shell, path: ".vagrant/apt.sh"
  config.vm.provision :shell, path: ".vagrant/puppet.sh"

  ### Virtalbox configuration
  #
  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.name   = "vagrantmaster"
    virtualbox.memory = 512
  end
end
