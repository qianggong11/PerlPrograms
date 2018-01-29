#!/usr/bin/perl
use strict;
use warnings;

my $ref  = shift or die("Usage: $0 <refence_file> <restricted_code>\n");
my $code = shift or die("Usage: $0 <refence_file> <restricted_code>\n");

open RF, $ref or die($!);
my $ch = -1;
my @seq;
while (<RF>) {
    chomp;
    if ( $_ =~ />.*/ ) {
        $ch++;
        next;
    }
    else {
        $seq[$ch] .= uc($_);
    }
}
close RF;

$ch = 0;
foreach my $x (@seq) {
    $ch++;
    my $p1 = -length($code) / 2;
    my $p2 = 0;
    while ( $p2 != -1 ) {
        $p2 = index( $x, $code, $p1 + 1 );
        print "$ch\t", $p1 + length($code) / 2, "\n";
        $p1 = $p2;
    }
}

