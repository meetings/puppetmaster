/* Class: whereami
 *
 * 2014-03-20 / Meetin.gs
 */
class common::whereami() {
    tag 'bootstrap'

    file {
        /* A simple script, which prints out the name of
         * the underlying dom0.
         */
        '/usr/bin/whereami':
            mode   => 0755,
            source => 'puppet:///modules/common/whereami';

        /* Key to access dom0.
         *
         * Permission here are crucial, because ssh(1) will
         * shit itself, if secret key file is readable by
         * world and is owned by current user. This basically
         * will break whereami command for user nobody, but
         * it should work for anyone else.
         */
        '/usr/local/lib/id_whereami':
            mode   => 0444,
            owner  => 'nobody',
            group  => 'nogroup',
            source => 'puppet:///modules/common/id_whereami';
    }
}
