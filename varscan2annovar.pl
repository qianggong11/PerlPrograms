#!/usr/bin/perl
use strict;
use warnings;

while (<>) {
    chomp;
    my @a  = split;
    my $lx = length( $a[2] );
    my $ly = length( $a[3] );
    if ( $lx == $ly ) {
        print join "\t", @a[ 0 .. 1 ], $a[1], @a[ 2 .. $#a ];
        print "\n";
    }
    else {
        my $newvar = substr( $a[3], 1 );
        if ( $a[3] =~ /^\+/ ) {
            print join "\t", @a[ 0 .. 1 ], $a[1], "-", $newvar;
        }
        else {
            print join "\t", @a[ 0 .. 1 ], $a[1] + $ly - 2, $newvar, "-";
        }
        if ( @a > 4 ) {
            print "\t";
            print join "\t", @a[ 4 .. $#a ];
        }
        print "\n";
    }
}

