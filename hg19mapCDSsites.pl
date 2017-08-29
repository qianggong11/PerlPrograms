#!/usr/bin/perl
use strict;
use warnings;

my $hg19map =
"/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Annotation/Genes/hg19.map";
my $gene = shift or die("Usage: $0 <Gene_symbol>\n");

open IN, $hg19map or die($!);
while (<IN>) {
    chomp;
    my @a = split;
    next unless $a[0] eq $gene;
    my @e1 = split /,/, $a[8];
    my @e2 = split /,/, $a[9];
    die("Unequal exon boundaries at Line $. of $hg19map\n") unless @e1 == @e2;
    my $cdsi = 0;
    if ( $a[2] eq "+" ) {

        for ( my $i = 0 ; $i <= $#e1 ; $i++ ) {
            for ( my $j = $e1[$i] ; $j <= $e2[$i] ; $j++ ) {
                next unless ( $j >= $a[5] && $j <= $a[6] );
                $cdsi++;
                print join "\t", $a[1], $j, $gene, $cdsi, int( $cdsi / 3 ) + 1;
                print "\n";
            }
        }
    }
    else {
        for ( my $i = $#e1 ; $i >= 0 ; $i-- ) {
            for ( my $j = $e2[$i] ; $j >= $e1[$i] ; $j-- ) {
                next unless ( $j >= $a[5] && $j <= $a[6] );
                $cdsi++;
                print join "\t", $a[1], $j, $gene, $cdsi, int( $cdsi / 3 ) + 1;
                print "\n";
            }
        }
    }
}
close IN;
