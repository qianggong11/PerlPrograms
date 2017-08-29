#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

my $tsv =
"/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Cosmic/CosmicMutantExportIncFus.tsv";
my $infile = shift or &usage;
&usage if $infile =~ /^-\S+/;
my $help;
my ( $cfd, $pfd, $inf ) = ( 1, 2, 3 );
my $gfd;
GetOptions(
    'input=s'     => \$infile,
    'tsvcosmic=s' => \$tsv,
    'chrom=i'     => \$cfd,
    'position=i'  => \$pfd,
    'level=i'     => \$inf,
    'gene=i'      => \$gfd,
    'help!'       => \$help,
);
&usage if $help;

my %pmids;
my %hissubs;
my %muttimes;
my %gtimes;
open IN, $tsv or die($!);
while (<IN>) {
    chomp;
    my @a = split /\t/;
    $gtimes{ $a[0] }++;
    my $k;
    next if @a <= 13;
    if ( $a[13] =~ /(\d+:\d+)-\d+/ ) {
        $k = "chr$1";
    }
    else {
        next;
    }
    $muttimes{$k}++;
    $hissubs{$k} .= "$a[6],";
    next if @a <= 14;
    $pmids{$k} .= "$a[14],";
}
close IN;

open IN, $infile or die($!);
while (<IN>) {
    chomp;
    my @a = split;
    my $k = join ':', $a[ $cfd - 1 ], $a[ $pfd - 1 ];
    my ( $pmid, $his, $time );
    if ( exists $pmids{$k} ) {
        $pmid = $pmids{$k};
        $his  = $hissubs{$k};
        $time = $muttimes{$k};
    }
    else {
        $pmid = 0;
        $his  = "None";
        $time = 0;
    }
    if ( $inf == 1 ) {
        print join "\t", @a, $time, $pmid;
    }
    elsif ( $inf == 2 ) {
        print join "\t", @a, $time, $his;
    }
    elsif ( $inf == 3 ) {
        print join "\t", @a, $time, $pmid, $his;
    }
    else {
        die( "Wrong -l Parameter: The level of information must be 1, 2, or 3\n"
        );
    }
    if ($gfd) {
        my $gt = 0;
        $gt = $gtimes{ $a[ $gfd - 1 ] } if exists $gtimes{ $a[ $gfd - 1 ] };
        print "\t$gt";
    }
    print "\n";
}
close IN;

sub usage {
    die(
        qq/
USAGE: pubmedID_from_cosmicMutTSV.pl <input_file> [OPTIONS]

OPTIONS:
		-t CosmicMutantExportIncFus.tsv 
			(Default: \/net\/isi-dcnl\/ifs\/user_data\/jochan\/Group\/qgong\/hg19\/Cosmic\/CosmicMutantExportIncFus.tsv)
		-c Chromosome field of the input file (1)
		-p Position field of the input file (hg19) (2)
		-g Gene symbol field if need gene times informed
		-l Level of information, 1 for only pubmed ID, 2 for only histology subtypes, 3 for both (default);
		-h show the USAGE
\n/
    );
}
