/* Class: cpan
 *
 * Enable installing modules from
 * Comprehensive Perl Archive Network.
 *
 * 2013-03-03 / Meetin.gs
 */
class common::cpan() {
    package {
        ['cpanminus', 'gcc', 'make']: ensure => installed;
    }
}
