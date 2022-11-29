#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use File::Basename qw( dirname );
use Cwd qw( abs_path );

my ( $dir ) = dirname(abs_path($0));
my $default_dir = $dir;

my $sniffed_hostname = `/bin/hostname`;
chomp $sniffed_hostname;

my $hostname = $sniffed_hostname;

my $front = '';

my $result = Getopt::Long::GetOptions(
    "dir=s"      => \$dir,
    "hostname=s" => \$hostname,
    "front=s"    => \$front,
);

die "Could not find portforward dir: $dir!\n" unless -d $dir;

my $rsa_file = '/root/id_pf';

die "Could not find rsa file: $rsa_file!\n" unless -f $rsa_file;

chdir $dir;
system "$dir/build.pl", $hostname;

my $location = "$dir/build/$hostname";

die "Could not find configuration dir after build: $location!\n" unless -d $location;

# This flushes something somewhere that otherwise causes some addresses
# to go unreachable sometimes.
if ($hostname eq $sniffed_hostname) {
    `/sbin/ifconfig eth0:112 10.0.0.112 up; /sbin/ifconfig eth0:112 down`;
}

$front ||= `/usr/bin/ssh-keygen -R 10.0.0.1 1>/dev/null 2>/dev/null; /usr/bin/ssh -o "StrictHostKeyChecking no" -o "CheckHostIP no" -i $rsa_file portforward\@10.0.0.1 /bin/hostname 2>/dev/null`;
chomp $front;

$front ||= 'hetzner-front';

my @configs = glob "$location/*";
my $front_moved_last = 0;

for my $file ( @configs ) {
    # Current front machine is moved as the last one to ensure so that other
    # connections which might have previously done some local port bindings
    # have been refreshed and do bind the ports anymore. Otherwise the new
    # front connection might not be able to bind the local ports.
    #
    # TODO: before running front ensure we might want to use netstat
    # to make sure that previous fronts which have now been removed from the
    # fronts list are not still running and binding the ports.
    #
    if ( ! $front_moved_last && $file eq "$location/$front.conf" ) {
        $front_moved_last = 1;
        push @configs, $file;
        next;
    }

    # Make sure DomU fronts do not try to connect themselves
    # This is not possible due to bridge being unwilling to pass packages back
    #
    next if $hostname =~ /hetzner.front/ && $file eq "$location/${front}_23.conf";

    my  @params = ();
    push @params, ( '--rsa_file', $rsa_file ) unless $default_dir eq $dir;
    push @params, ( '--disable_local' ) unless $file eq "$location/$front.conf";
    system( "$dir/ensure_connection.pl", "$file", @params );
}
