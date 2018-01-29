#!/usr/bin/perl
use strict;
use warnings;

## identify LOH regions from the *.snp produced by varscan2

my $lstat = 0;
my $lpos  = 0;
my $lchr  = 0;
my $spos  = 0;
my $nsite = 1;

while (<>) {
    chomp;
    my @a = split;
    next if ( $a[4] < 4 || $a[5] < 4 || ( $a[13] > 0.05 && $a[14] > 0.05 ) );
    if ( $a[12] eq "LOH" ) {
        if ($lstat) {
            if ( $a[0] eq $lchr ) {
                $lpos = $a[1];
                $nsite++;
            }
            else {
                print "$lchr:$spos-$lpos\t$nsite\n" if $lpos;
                $nsite = 1;
                $lchr  = $a[0];
                $lpos  = 0;
            }
        }
        else {
            $lchr  = $a[0];
            $spos  = $a[1];
            $lstat = 1;
        }
    }
    else {
        next unless $lstat;
        print "$lchr:$spos-$lpos\t$nsite\n" if $lpos;
        $nsite = 1;
        $lstat = 0;
        $lpos  = 0;
    }
}

