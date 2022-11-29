/* Define: addsecret
 *
 * 2015-08-16 / Meetin.gs
 */
define common::addsecret($file=$title, $path) {
    file { "${path}.asc":
        mode   => 0400,
        source => "puppet:///modules/${caller_module_name}/secret/${file}",
        notify => Exec["secret_${file}"];
    }

    exec { "secret_${file}":
        command     => "cat ${path}.asc | \
                        timeout -k 5 5 ssh -Ti /root/id_keeper keeper@10.0.0.1 | \
                        tee ${path} && \
                        /usr/bin/run_post_decrypt_hooks.sh ${path}",
        path        => ['/bin', '/usr/bin', '/usr/local/bin' ],
        require     => [
                           File['/root/id_keeper'],
                           File['/usr/bin/run_post_decrypt_hooks.sh']
                       ],
        refreshonly => true;
    }
}
