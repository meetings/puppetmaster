/* Class: users
 *
 * Let analytistic users access the machine.
 *
 * 2014-07-25 / Meetin.gs
 */
class miner::users() {
    common::adduser {
        'antero': comment => 'Antero Aalto';
        'arkkis': comment => 'Mikko Tapionlinna';
        'teemu':  comment => 'Teemu Arina';
    }
}
