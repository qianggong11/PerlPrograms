#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

## Author: Qiang Gong <qgong@coh.org>

## based on the results from Costello et al, 2013
## filter sites mutations with TLOD <= -10 + ( 100 / 3 ) * FOXOG

my $help;
my $invcf = shift or &usage;
my $outvcf;
if ( $invcf =~ /^(\S+)\.vcf$/ ) {
    $outvcf = "$1.DToxoG.vcf";
}
else {
    $outvcf = "$invcf.DToxoG.vcf";
}

GetOptions(
    'output=s' => \$outvcf,
    'help!'    => \$help,
);
&usage if $help;

open OT, ">$outvcf";
select(OT);

my $filterheader = 0;
my $colnum;
open IN, $invcf or die($!);
while (<IN>) {
    chomp;
    if (/^#/) {
        if ( $filterheader == 1 && $_ !~ /^##FILTER/ ) {
            print "##FILTER=<ID=oxoG_artifact,Description=\"likely an oxoG artifact\">\n";
            $filterheader = 0;
        }
        $filterheader = 1 if /^##FILTER/;
        print "$_\n";
        if (/^#CHROM/) {
            my @a = split;
            $colnum = $#a;
        }
        next;
    }
    my @a = split;
    if ( $#a != $colnum ) {
        print STDERR "WARNING: Lines with unexpected #columns in $invcf: $_\n";
        next;
    }
    if ( length( $a[3] ) == 1 && length( $a[4] ) == 1 ) {
        if ( &DToxoGFilter( @a[ 7, 9 ] ) ) {
            if ( $a[6] eq "PASS" ) {
                $a[6] = "oxoG_artifact";
            }
            else {
                $a[6] .= ";oxoG_artifact";
            }
        }
    }
    print join "\t", @a;
    print "\n";
}
close IN;

sub DToxoGFilter {
    my $r = 0;
    my @nums = split /:/, $_[1];
    my $tlod;
    if ( $_[0] =~ /TLOD=([0-9\.]+)/ ) {
        $tlod = $1;
    }
    else {
        print STDERR "Cound not find TLOD information:\n$_[0]\n";
        return $r;
    }
    return $r unless $#nums == 8 or $#nums == 10;
    my $foxog = $nums[5];
    return $r if $foxog eq ".";
    return $r unless $tlod <= -10 + ( 100 / 3 ) * $foxog;
    $r = 1;
}

sub usage {
    die(
        qq/
USAGE: DToxoG_MuTect2VCF.pl [OPTIONS] <*.vcf> 

	variant file - A VCF file of SNPs or indels produced by MuTect2
	OPTIONS:
		--output STR  name of output files (Default: INPUTNAME.DToxoG.vcf)

CONTACT: Qiang Gong <qgong\@coh.org>

\n/
    );
}
