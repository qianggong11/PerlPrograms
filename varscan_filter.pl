#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

## Author: Qiang Gong <qgong@coh.org>

## work similarly as varscan filter

my $ipfi;
my ( $mcov, $mre2, $strf, $mvfr, $pval, $opfi, $help ) =
  ( 10, 4, 1, 0.2, 0.01,, );
GetOptions(
    'input|i=s'       => \$ipfi,
    'min-coverage=i'  => \$mcov,
    'min-reads2=i'    => \$mre2,
    'strand-filter:1' => \$strf,
    'min-var-freq=f'  => \$mvfr,
    'p-value=f'       => \$pval,
    'output-file=s'   => \$opfi,
    'help!'           => \$help,
);
$ipfi or &usage;
&usage if $help;

if ($opfi) {    # redirect if output file is assigned
    open OT, ">$opfi";
    select(OT);
}

open IN, $ipfi or die($!);
while (<IN>) {
    chomp;
    my ( $chro, $posi, $refa, $muta, $info, $pass ) = split;
    if (/^Chrom/) {
        print join "\t", $chro, $posi, $refa, $muta, $info, $pass;
        print "\n";
        next;
    }
    my @dept = split /:/, $info;
    my @dp4f = split /:/, $pass;
    next unless $dept[1] >= $mcov;               # min-coverage
    next unless $dept[3] >= $mre2;               # min-read2
    next unless ( 
		    $strf == 0 || 
		    ( @dp4f < 7 && 
			 $dp4f[3] * $dp4f[4] != 0 
			 ) );                             # strand-filter
    next unless $dept[3] / $dept[1] >= $mvfr;    # min-var-freq
    next unless $dept[5] < $pval;                # p-value
    print join "\t", $chro, $posi, $refa, $muta, $info, $pass;
    print "\n";
}
close IN;

sub usage {
    die(
        qq/
USAGE: varscan_filter.pl -i <variant file> [OPTIONS]

	variant file - A file of SNPs or indels produced by VarScan mpileup2snp (v2.3.6 or maybe above)
	               There should be only one sample processed during the previous mpileup step

OPTIONS:
        --min-coverage  Minimum read depth at a position to make a call [10]
        --min-reads2    Minimum supporting reads at a position to call variants [4]
        --strand-filter Ignore variants with >90% support on one strand [1]
        --min-var-freq  Minimum variant allele frequency threshold [0.20]
        --p-value       Default p-value threshold for calling variants [0.01]
        --output-file   File to contain variants passing filters [STDOUT]
        --help\/-h       Print this page

CONTACT: Qiang Gong <qgong\@coh.org>

\n/
    );
}
