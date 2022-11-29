/* Class: packages
 *
 * 2015-07-07 / Meetin.gs
 */
class common::packages() {
    $packages = [
        /* Commonly used packages, which ought to be installed.
         */
        'bc', 'curl', 'dnsutils', 'ethtool', 'git', 'iptables',
        'man-db', 'moreutils', 'mtr-tiny', 'nano', 'pv', 'screen',
        'telnet', 'traceroute', 'unattended-upgrades', 'vim',
        'xz-utils',

        /* Packages, which should be kept up to date, and are
         * thus listed here.
         */
        'apt', 'base-files', 'bash', 'ca-certificates', 'dpkg',
        'facter', 'gnupg', 'openssh-client', 'openssh-server',
        'openssl', 'puppet', 'rsync', 'sudo', 'tzdata', 'wget'
    ]

    package {
        $packages: ensure => latest
    }
}
