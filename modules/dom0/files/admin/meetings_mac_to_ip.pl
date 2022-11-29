#!/usr/bin/perl -pW

use strict;

sub toip($) {
  my $mac = $_[0];
  my $ifoutput = `ifconfig dicolerootnet`;
  my ( $ipstart ) = $ifoutput =~ /inet addr:\s*(\d+\.\d+)/;
  $ipstart ||= '10.0';
  if ($mac =~ /\w+:\w+:\w+:\w+:(\w+):(\w+)/) {
    my $end = join(".", hex($1), hex($2));
    $end =~ s/^0.1$/255.255/;
    return join(".", $ipstart, $end);
  }
}

$_ = '' if /^dhcp/;

if (/^vif/) {
  unless (/ip=/) {
    s/mac=([\w:]+)/"ip=".toip($1).",mac=$1"/e;
  }
}
