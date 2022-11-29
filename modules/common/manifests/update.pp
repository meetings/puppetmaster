/* Class: update
 *
 * 2014-10-06 / Meetin.gs
 */
class common::update() {
    tag 'bootstrap'

    exec { 'apt-update':
        command => '/usr/bin/apt-get -q update';
    }

    Exec['apt-update'] -> Package <| title != 'mysql-client' |>
}
