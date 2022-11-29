#!/usr/bin/perl

use File::Basename;
my $dirname = dirname(__FILE__);

my $hosts = shift @ARGV;
my $command = shift @ARGV;
my $ld = shift @ARGV;
my $timeout = shift @ARGV || "5";
my $silent_failure = shift @ARGV;

my $max = 10;
my $count = 0;
for my $host ( split /\s+/, $hosts ) {
    if ( fork ) {
        $count++;
        if ( $count >= $max ) {
            wait;
            $count--;
        }
    }
    else {
        system( $dirname . "/helper_run_on_machine.pl", $host, $command, $ld, $timeout, $silent_failure );
        exit 0;
    }
}
while (wait() != -1) {}
