/* Class: elk
 *
 * 2015-04-02 / Meetin.gs
 */
class nginx::elk() inherits nginx {
    nginx::enable {
        'kibana.meetin.gs':;
    }

    file { '/etc/nginx/passwd':
        mode   => 0400,
        owner  => 'www-data',
        group  => 'www-data',
        source => 'puppet:///modules/nginx/passwd';
    }
}
