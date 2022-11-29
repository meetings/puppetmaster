#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my $rsa_file = '/root/id_pf';
my $disable_local = 0;

my $result = Getopt::Long::GetOptions(
    "rsa_file=s"    => \$rsa_file,
    "disable_local" => \$disable_local
);

my @a = @ARGV;

my $file = shift @a;

my $conf = do $file;
#$conf->{local_ssh_gateway_port} = $ARGV[1] if $ARGV[1];

my $redirects = $conf->{redirects} || [];

unshift @$redirects, {
    gateway_port => $conf->{local_ssh_gateway_port},
    port => $conf->{local_ssh_port} || 22,
};

my @gateways = map { $_->{gateway_port} ? '-R' . join( ':', ( $_->{gateway_listen} || '*', $_->{gateway_port}, $_->{host} || '127.0.0.1', $_->{port} ) ) : () } @$redirects;

my @forwards;

if ( ! $disable_local ) {
    @forwards = map { $_->{forward_port} ? '-L' . join( ':', ( $_->{forward_listen} || '*', $_->{forward_port}, $_->{host} || '127.0.0.1', $_->{port} ) ) : () } @$redirects;
}

# There is no need to create the tunnel if this is not a gateway front and no extra tunnels are defined
exit 0 unless scalar( @forwards ) || scalar( @gateways ) > 1 || $conf->{front_config} =~ /gw|gateway/;

my @redirects = ( @gateways, @forwards );
my @gateway_port_string = $conf->{gateway_ssh_port} ? ( '-p ' . $conf->{gateway_ssh_port} ) : ();
my @gateway_target_string = ( join '@', ( $conf->{gateway_ssh_user} || (), $conf->{gateway_ssh_host} ) );

my $rsa_string = '';
if ( -f $rsa_file ) {
    $rsa_string = "-i $rsa_file ";
}

# Do NOT use -N because it makes the connections lag if idle even a moment (somewhere around 1 second).
# feed constant stream of 1's to keep the connection not lagging
my $command = 'ssh ' . $rsa_string . '-o "StrictHostKeyChecking no" -o "CheckHostIP no" -c arcfour -f ' .
    join( " ", ( @gateway_port_string, @redirects, @gateway_target_string ) ) . ' "while (sleep 0.5); do echo 1; done"';

my $stripped_command = $command;
$stripped_command =~ s/"//g;

my $listing = `/bin/ps ax`;
if ( index( $listing, $command ) == -1 && index( $listing, $stripped_command) == -1 ) {
    killall();
    exec( $command );
}
else {
    ensure_own_key_in_authorized_keys();

    my $ok_host_string = join( '@', $conf->{local_ssh_user} || (), $conf->{local_ssh_gateway_host} || $conf->{gateway_ssh_host} );

    my $ok_string = 'ssh -o "StrictHostKeyChecking no" -o "CheckHostIP no" -o "ConnectTimeout 5" ' .
        '-p ' . $conf->{local_ssh_gateway_port} . ' ' . $ok_host_string . ' echo 1';
    my $ok = `$ok_string`;
    chomp $ok;
    unless ( $ok eq '1') {
        killall();

    # These ensure operation if failure was due to RSA key changing
    # TODO: this is also a security threat ;) figure out a way to mitigate it

    my $gwh = $conf->{gateway_ssh_host};
    system "/usr/bin/ssh-keygen", "-R", $gwh;

    my $lgwh = $conf->{local_ssh_gateway_host};
    system "/usr/bin/ssh-keygen", "-R", $lgwh if $lgwh;

        exec( $command );
    }
}

sub ensure_own_key_in_authorized_keys {
    `/usr/bin/ssh-keygen -q -f /root/.ssh/id_rsa -N ''` unless -e '/root/.ssh/id_rsa.pub';

    my $key = `cat /root/.ssh/id_rsa.pub`;
    chomp $key;
    my $authorized = `cat /root/.ssh/authorized_keys`;

    `cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys`
        if index($authorized, $key) == -1;
}

sub killall {
    for ( 1..5) {
        my $ax = `/bin/ps ax`;
        my $match = "-p ".$conf->{gateway_ssh_port}.".*\\-R\\*\\:" . $conf->{local_ssh_gateway_port} . "\\:";
        my ( $pid ) = $ax =~ /^\s*(\d+).*\sssh\s.*$match.*$conf->{gateway_ssh_host}/m;
        last unless $pid;
        system( "kill $pid" );
        sleep 1;
    }
}
