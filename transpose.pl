#!/usr/bin/perl
use strict;
use warnings;

my $mat;
my $jm = 0;
my $i  = 0;
while (<>) {
    chomp;
    my @a = split;
    die("Un-equal columns at Line $.\n") unless $jm == 0 or $jm == $#a;
    $jm = $#a;
    for ( my $j = 0 ; $j <= $#a ; $j++ ) {
        $mat->[$i][$j] = $a[$j];
    }
    $i++;
}

for ( my $j = 0 ; $j <= $jm ; $j++ ) {
    for ( my $k = 0 ; $k < $i ; $k++ ) {
        print "$mat->[$k][$j]\t";
    }
    print "\n";
}

