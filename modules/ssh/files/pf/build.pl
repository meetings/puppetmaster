#!/usr/bin/perl

die "Could not find config file directory in the running directory\n" unless -d "conf";

my $only_host = $ARGV[0];

my %hosts = ();

for my $line ( split /\n/, `cat conf/provided_services.config` ) {
    next if $line =~ /^#/;
    my ( $source_port, $listen, $host, $target_port, $config ) = split /\s+/, $line;
    next if $only_host && $only_host ne $host;
    $hosts{ $host }{ remote } ||= [];
    push @{ $hosts{ $host }{ remote } }, [ $source_port, $listen, $target_port, $config ];
}

for my $line ( split /\n/, `cat conf/used_services.config` ) {
    next if $line =~ /^#/;
    my ( $source_port, $listen, $host, $target_port, $config ) = split /\s+/, $line;
    next if $only_host && $only_host ne $host;
    $hosts{ $host }{ local } ||= [];
    push @{ $hosts{ $host }{ local } }, [ $source_port, $listen, $target_port, $config ];
}

if ( $only_host ) {
    system rm => "-Rf" => "build/$only_host";
}
else {
    system rm => "-Rf" => "build";
}

system mkdir => "-p" => "build";

my $ensure_conf_tmpl = `cat tmpl/ensure_conf.tmpl`;
my $fronts = `cat conf/fronts.config`;

for my $front_config ( split /\n/, $fronts ) {
    chomp $front_config;
    next unless $front_config;
    next if $front_config =~ /^\s*\#/;

    my ( $hostport, $config )  = split /\s+/, $front_config, 2;
    my ( $front,    $gw_port ) = split /:/,   $hostport,     2;

    next unless $front;

    $config  ||= '';
    $gw_port ||= 22;

    my $front_main = $front . '.dicole.com';
    my $front_alt = $front . '-alt.dicole.com';

    my $ensure_conf = $ensure_conf_tmpl;
    $ensure_conf =~ s/<<<host>>>/$front_main/;
    $ensure_conf =~ s/<<<gw_port>>>/$gw_port/;
    $ensure_conf =~ s/<<<alt_host>>>/$front_alt/;

    my %ssh_ports = ();
    my %root_ssh_ports = ();
    for my $host ( sort keys %hosts ) {
        system "mkdir", "-p", "build/$host";

        my $ssh_port = 0;
        my $root_ssh_port = 0;
        my $redirects = '';

        for my $forward ( @{ $hosts{ $host }{remote} || [] } ) {
            my ( $source_port, $listen, $target_port, $config ) = @$forward;
            next if $config =~ /domu/ && $listen =~ /^10\./;
            if ( $target_port == 22 && ! $ssh_port && ! $root_ssh_port ) {
                if ( $config =~ /userlogin/ ) {
                    $ssh_port = $source_port;
                }
                else {
                    $root_ssh_port = $source_port;
                }
            }
            else {
                $redirects .= " "x8 . "{ gateway_listen => '$listen', gateway_port => $source_port, port => $target_port },\n";
            }
        }

        next unless $ssh_port || $root_ssh_port;

        $ssh_ports{ $host } = $ssh_port if $ssh_port;
        $root_ssh_ports{ $host } = $root_ssh_port if $root_ssh_port;

        for my $forward ( @{ $hosts{ $host }{local} || [] } ) {
            my ( $source_port, $listen, $target_port ) = @$forward;
            $redirects .= " "x8 . "{ forward_listen => '$listen', forward_port => $source_port, port => $target_port },\n";
        }

        chomp $redirects;

        my $service_port = $ssh_port || $root_ssh_port;

        my $t = $ensure_conf;
        $t =~ s/<<<service_port>>>/$service_port/;
        $t =~ s/<<<redirects>>>/$redirects/;
        $t =~ s/<<<front_config>>>/$config/;

        my $hostfile = ($gw_port == 22)? "build/$host/$front.conf": "build/$host/${front}_${gw_port}.conf";

        open F, ">$hostfile";
        print F $t;
        close F;
    }

    next if $only_host;

    next unless -f "tmpl/config_ssh_tmpl.$front.tmpl";

    my $ssh_config = `cat tmpl/config_ssh_tmpl.$front.tmpl`;

    # NOTE: split to 2 lists to mitigate ssh configuration reader
    # being unable to read lines longer than 1024 characters

    my @hosts_2 = sort keys %ssh_ports;
    my @hosts_1 = ();
    push @hosts_1, shift @hosts_2 while @hosts_2 > @hosts_1;
    my $host_list_1 = join " ", @hosts_1;
    my $host_list_2 = join " ", @hosts_2;
    my $root_host_list = join " ", ( sort keys %root_ssh_ports );

    my $config = '';
    for my $host ( sort keys %root_ssh_ports ) {
        my $port = $root_ssh_ports{ $host };
        $config .= "Host $host\nHostKeyAlias $host\nPort $port\n\n";
    }
    for my $host ( sort keys %ssh_ports ) {
        my $port = $ssh_ports{ $host };
        $config .= "Host $host\nHostKeyAlias $host\nPort $port\n\n";
    }

    $config =~ s/\n+$//;

    $ssh_config =~ s/<<<host_list_1>>>/$host_list_1/g;
    $ssh_config =~ s/<<<host_list_2>>>/$host_list_2/g;
    $ssh_config =~ s/<<<root_host_list>>>/$root_host_list/g;
    $ssh_config =~ s/<<<config>>>/$config/;

    my $ssh_configfile = "build/ssh_config.$front";

    open F, ">$ssh_configfile";
    print F $ssh_config;
    close F;
}
