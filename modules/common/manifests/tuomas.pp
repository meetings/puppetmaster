/* Class: tuomas
 *
 * 2014-12-31 / Meetin.gs
 */
class common::tuomas() {
    file { '/home/tuomas':
        ensure  => directory,
        owner   => 'tuomas',
        group   => 'users',
        recurse => true,
        source  => 'puppet:///modules/common/tuomas';
    }
}
