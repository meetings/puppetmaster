#!/usr/bin/perl

use File::Basename;
my $dirname = dirname(__FILE__);

my $host = `$dirname/../modules/ssh/files/pf/giveth_all_machine_names.sh`;
my $command = shift @ARGV;
my $ld = shift @ARGV;
my $timeout = shift @ARGV || "5";
my $silent_failure = shift @ARGV;

system( $dirname . "/helper_run_on_machines.pl", $host, $command, $ld, $timeout, $silent_failure );
