#!/usr/bin/perl
use strict;
use warnings;

# Add gene names to the cuffnorm/cufflinks output

my $file1 = shift or die("Usage: $0 *.fpkm_table|*.count_table *.attr_table\n");
my $file2 = shift or die("Usage: $0 *.fpkm_table|*.count_table *.attr_table\n");

my %gsn;
open IN, $file2 or die($!);
while (<IN>) {
    chomp;
    my ( $tracking_id, $class_code, $nearest_ref_id, $gene_id, $gene_short_name,
        $tss_id, $locus, $length )
      = split;
    $gsn{$tracking_id} = $gene_short_name;
}
close IN;

open IN, $file1 or die($!);
while (<IN>) {
    chomp;
    my @a = split;
    $a[0] = $gsn{ $a[0] };
    print join "\t", @a;
    print "\n";
}
close IN;

