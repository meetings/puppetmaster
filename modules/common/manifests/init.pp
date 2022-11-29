/* Module: common
 *
 * 2015-08-16 / Meetin.gs
 */
class common() {
    stage { 'early': }
    stage { 'late': }
    Stage['early'] -> Stage['main'] -> Stage['late']

    /* Set up package management in stages.
     *
     * 1) Configure apt(8) and set up repositories.
     * 2) Synchronize package index.
     * 3) Install packages.
     */
    class {
        'common::apt':        stage => early;

        'common::update':     stage => main;

        'common::packages':   stage => late;
        'common::touch':      stage => late;
    }

    /* Do many things unconditionally everywhere.
     */
    class {
        'common::clean':;
        'common::diskcheck':;
        'common::puppet':;
        'common::timezone':;
        'common::users':;
        'common::sheetstate':;
    }

    /* Do some things only on domUs.
     */
    if $::class == 'domU' {
        class {
            'common::repository': stage => early;
            'common::modcheck':;
            'common::ntpdate':;
            'common::whereami':;
        }
    }

    /* Create a directory for Meetin.gs specific software.
     * Drop access key for The Keeper of Secrets.
     * Make alert scripts available.
     * Make shell script library available.
     */
    file {
        '/opt/meetings':
            ensure => directory,
            mode   => 0755;

        '/root/id_keeper':
            mode   => 0400,
            source => 'puppet:///modules/common/id_keeper';

        '/usr/local/bin/sms':
            mode   => 0755,
            source => 'puppet:///modules/common/sms';
        '/usr/local/bin/wrap':
            mode   => 0755,
            source => 'puppet:///modules/common/wrap';

        '/usr/local/lib/libmeetings.sh':
            mode   => 0644,
            source => 'puppet:///modules/common/libmeetings.sh';

        '/etc/post_decrypt_hooks.d':
            ensure => directory,
            mode   => 0755;
        '/usr/bin/run_post_decrypt_hooks.sh':
            mode   => 0755,
            source => 'puppet:///modules/common/run_post_decrypt_hooks.sh';
    }
}
