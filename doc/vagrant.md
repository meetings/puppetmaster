
# Vagrant

[base]: http://www.skoblenick.com/vagrant/creating-a-custom-box-from-scratch

## Creation of base box

For more information, see [this article][base].

1. Create a new virtual machine. With VirtualBox, do the following:

    + Disable USB and audio support
    + Add ssh forwarding rule (2222 => 22)

2. Install 32-bit version of guest OS. Make sure following user is created:

    + Username: vagrant
    + Password: vagrant

3. Add *puppet* to */etc/hosts* and fire up a ssh tunnel.

        $ ssh -vNL 8140:10.0.0.1:8140 root@gateway.dicole.com

4. Install puppet agent and do the usual. Use the name *basebox* when running
   puppet agent.

        # apt-get install puppet
        # puppet agent --certname basebox --onetime --no-daemonize --verbose
        # apt-get dist-upgrade
        # puppet agent --certname basebox --onetime --no-daemonize --verbose

5. Install VirtualBox Additions.

        # mount -t iso9660 -r /dev/sr0 /mnt
        # /mnt/VBoxLinuxAdditions.run
        # umount /mnt

6. Remove unnecessary kernels, clean up and shutdown.

7. Trim and convert the virtual disk, if required.

        $ VBoxManage modifyhd <disk.vdi> --compact
        $ VBoxManage clonehd <in.vdi> <out.vmdk> --format vmdk

8. Create a package.

        $ vagrant package --base <VM name> --output <filename.box>
