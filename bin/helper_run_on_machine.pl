#!/usr/bin/perl

my $host = shift @ARGV;
my $command = shift @ARGV;
my $ld = shift @ARGV;
my $timeout = shift @ARGV || "5";
my $show_failures = shift @ARGV;

if (! $command || ! $host) {
    print STDERR "Needs a host and a command\n";
    exit 1;
}

my $ec = $command;
$ec =~ s/'/'"'"'/g;

my $ok = `sh -c 'mp=\$\$;(sleep $timeout; pkill -P \$mp) & cp=\$!; ssh -o StrictHostKeyChecking=no $host echo ok; pkill -P \$cp' 2>/dev/null`;
chomp $ok;

my $error = "";
if ( $ok ne "ok" ) {
    $error = "ERROR - Could not connect to host in $timeout seconds\n";
}

exit 0 if $error && ! $show_failures;

my $result = $error;
$result ||= `ssh -o StrictHostKeyChecking=no $host bash -c "'"'$ec'"'" 2>&1`;
$result .= "\n" unless $result =~ /\n$/s;

if ( $ld ) {
    `mkdir -p $ld`;
    open my $fh, ">", "$ld/$host" or die "could not open $ld/$host";
    print $fh $result;
    close $fh;
    my $md5 = `md5 -q $ld/$host`;
    `mv $ld/$host $ld/$host-$md5`;
}
else {
    if ( $error ) {
        if ( $show_failures ) {
            print STDERR "$host :: $result";
            exit 1;
        }
    }
    else {
        print "$host :: $result";
    }
}
