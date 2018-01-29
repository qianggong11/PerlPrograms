#!/usr/bin/perl
use strict;
use warnings;

my $s=shift or die("Usage: $0 <string>");

print length($s),"\n";

