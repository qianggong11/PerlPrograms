#!/usr/bin/perl
use strict;
use warnings;

my $file = shift
  or die("$0 <depth_file> <*.fa.fai> <window_size(int)> <step(int)>");
my $fai = shift
  or die("$0 <depth_file> <*.fa.fai> <window_size(int)> <step(int)>");
my $winsize = shift
  or die("$0 <depth_file> <*.fa.fai> <window_size(int)> <step(int)>");
my $step = shift
  or die("$0 <depth_file> <*.fa.fai> <window_size(int)> <step(int)>");

my %chsiz;
open IN, $fai or die($!);
while (<IN>) {
    chomp;
    my ( $ch, $size ) = split;
    $chsiz{$ch} = $size;
}
close IN;

my $cur_chr = "chr0";
my @depths;
my %sdep;

open IN, $file or die($!);
while (<IN>) {
    chomp;
    my ( $ch, $pos, $dep ) = split;
    if ( $ch ne $cur_chr ) {
        foreach ( keys %sdep ) {
            print "$cur_chr\t$_\t", $sdep{$_} / $winsize, "\n";
        }
        %sdep    = ();
        $cur_chr = $ch;
    }
    my $minstart = ( int( ( $pos - $winsize - 1 ) / $step ) + 1 ) * $step + 1;
    my $maxstart = int( ( $pos - 1 ) / $step ) * $step + 1;
    foreach ( keys %sdep ) {
        if ( $_ < $minstart ) {
            print "$ch\t$_\t", $sdep{$_} / $winsize, "\n";
            delete $sdep{$_};
        }
    }
    for ( my $k = $minstart ; $k <= $maxstart ; $k += $step ) {
        $sdep{$k} += $dep;
    }    ## $k: The start postions of sliding windows;
}
foreach ( keys %sdep ) { print "$cur_chr\t$_\t", $sdep{$_} / $winsize, "\n"; }
