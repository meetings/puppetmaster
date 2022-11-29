/* Class: xen
 *
 * 2015-01-08 / Meetin.gs
 */
class dom0::xen($dom0_mem) {
    class {
        'dom0::crypt':;
    }

    $packages = [
        'xen-system-amd64',
        'xen-tools',
        'liblog-message-perl'
    ]

    package {
        $packages: ensure => installed
    }

    file {
        /* Make Xen-enabled kernel the default.
         *
         * Template uses:
         *  $dom0_mem
         */
        '/etc/default/grub.d/xen.cfg':
            mode    => 0644,
            content => template('dom0/xen.cfg.erb'),
            require => Package['xen-system-amd64'];

        '/etc/xen/xl.conf':
            mode    => 0644,
            source  => 'puppet:///modules/dom0/xl.conf',
            require => Package['xen-system-amd64'];

        /* On xen-tools, remove stupid guess script and
         * make domU configuration template better.
         */
        '/etc/xen-tools/xen-tools.conf':
            mode    => 0644,
            source  => 'puppet:///modules/dom0/xen-tools.conf',
            require => Package['xen-tools'];
        '/etc/xen-tools/xm.tmpl':
            mode    => 0644,
            source  => 'puppet:///modules/dom0/xm.tmpl',
            require => Package['xen-tools'];

        /* Modify domU creation hooks and add Meetin.gs role.
         */
        '/usr/share/xen-tools/trusty.d/20-setup-apt':
            mode    => 0755,
            source  => 'puppet:///modules/dom0/20-setup-apt',
            require => Package['xen-tools'];
        '/usr/share/xen-tools/trusty.d/50-setup-hostname':
            mode    => 0755,
            source  => 'puppet:///modules/dom0/50-setup-hostname',
            require => Package['xen-tools'];

        /* Include domU provisioning scripts.
         */
        '/etc/xen-tools/role.d/meetings':
            mode    => 0755,
            source  => 'puppet:///modules/dom0/meetings.role',
            require => Package['xen-tools'];
        '/usr/local/lib/rc.local.domU':
            mode    => 0644,
            source  => 'puppet:///modules/dom0/rc.local.domU';
        '/usr/local/lib/provision.domU':
            mode    => 0644,
            source  => 'puppet:///modules/dom0/provision.domU';
    }

    /* Disable saving/restoring of domU and rather
     * do full shutdown when dom0 goes down.
     */
    augeas { 'xendomains':
        context => '/files/etc/default/xendomains',
        changes => 'set XENDOMAINS_SAVE ""',
        require => Package['xen-system-amd64'];
    }
}
