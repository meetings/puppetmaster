/* Define: openport
 *
 * Open desired port to the world.
 *
 * 2014-01-30 / Meetin.gs
 */
define ssh::openport($port=$title) {
    augeas { "open${port}":
        context => '/files/etc/ssh/sshd_config',
        changes => [
            'ins Port after Port[last()]',
            "set Port[last()] ${port}"
        ],
        onlyif  => "get Port[. = '${port}'] != ${port}";
    }
}
