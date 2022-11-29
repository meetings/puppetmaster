/* Module: mysql
 *
 * Simple Mysql configuration without
 * any resiliency or redundancy.
 *
 * 2013-08-04 / Meetin.gs
 */
class mysql() {
    class { 'mysql::common': }
}
