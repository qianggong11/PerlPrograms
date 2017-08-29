#!/usr/bin/perl
use strict;
use warnings;

my $file = shift or die("Usage: $0 <Matrix_file_U133.gz>\n");
my $u133dict = "/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Annotation/HG-U133A_2.na34.annot.txt";

my %u133gs;
open IN, $u133dict or die($!);
while (<IN>) {
    chomp;
    my @a = split;
    $u133gs{ $a[0] } = $a[1];
}
close IN;

$u133gs{"ID_REF"} = "GeneSymbol";
open my $fh, '-|', '/usr/bin/gunzip', '-c', $file or die($!);
while (<$fh>) {
    chomp;
    next if /^$/ or /^!/;
    s/"//g;
    my @a = split /\t/;
    next unless exists $u133gs{ $a[0] };
    $a[0] = $u133gs{ $a[0] };
    print join "\t", @a;
    print "\n";
}
close $fh;
