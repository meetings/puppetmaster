/* Class: users
 *
 * 2014-04-23 / Meetin.gs
 */
class dom0::users() {
    common::adduser {
        'keeper':      comment => 'Keeper of secrets';
        'portforward': comment => 'Portforwarder';
    }
}
