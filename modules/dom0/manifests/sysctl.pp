/* Define: sysctl
 *
 * Configure sysctl.conf. New values are not loaded
 * and a reboot may be required. Usage example:
 *
 * bofh::sysctl {
 *   'vm.swappiness': value => 10;
 *   'net.ipv4.ip_forward': value => 1;
 * }
 *
 * 2012-10-16 / Meetin.gs
 */
define dom0::sysctl($value, $key = $name) {
    augeas { "sysctl.conf.${key}":
        context => '/files/etc/sysctl.conf',
        changes => "set $key '$value'",
        onlyif  => "get $key != '$value'"
    }
}
