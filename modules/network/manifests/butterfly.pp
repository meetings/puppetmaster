/* Class: butterfly
 *
 * 2014-02-09 / Meetin.gs
 */
class network::butterfly() {
    file {
        '/usr/local/lib/pb':
            ensure  => directory;
        '/usr/local/sbin/meetings_pb_route_select.sh':
            mode   => 0755,
            source => 'puppet:///modules/network/meetings_pb_route_select.sh';
    }

    network::addpbconf {
        'mm-mysql':
            public => '29994',
            normal => '29993',
            domU_1 => '20085',
            domU_2 => '20087';
        'blog-mysql':
            public => '29997',
            normal => '29996',
            domU_1 => '20094',
            domU_2 => '20096';
        'test-mysql':
            public => '29987',
            normal => '29986',
            domU_1 => '20101',
            domU_2 => '20102';
    }
}
