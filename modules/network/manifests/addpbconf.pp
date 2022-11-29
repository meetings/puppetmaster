/* Define: addpbconf
 *
 * 2014-02-09 / Meetin.gs
 */
define network::addpbconf(
    $public,
    $normal,
    $domU_1,
    $domU_2,
) {
    file { "/usr/local/lib/pb/${title}.conf":
        mode    => 0644,
        content => template('network/pb.conf.erb'),
        require => File['/usr/local/lib/pb'];
    }
}
