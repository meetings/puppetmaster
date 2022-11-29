/* Class: packages
 *
 * 2014-01-14 / Meetin.gs
 */
class localdev::packages() {
    $packages = [
        'curl', 'dkms', 'dnsutils', 'git', 'iptables', 'man-db',
        'moreutils', 'nano', 'packages-available', 'screen',
        'telnet', 'vim'
    ]

    package {
        $packages: ensure => latest
    }
}
