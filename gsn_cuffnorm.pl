#!/usr/bin/perl
use strict;
use warnings;

# Replace "tracking_id" with "gene_short_name" based on genes.attr_table
# from cuffnorm output
# 
# Author: Qiang Gong <qgong@coh.org>
# 11/9/2015


my $file1 = shift or die("Usage: $0 <genes.count_table/genes.fpkm_table> <genes.attr_table>\n");
my $file2 = shift or die("Usage: $0 <genes.count_table/genes.fpkm_table> <genes.attr_table>\n");

my %gsn;
open IN, $file2 or die($!);
while (<IN>){
	chomp;
	my @a = split;
	$gsn{$a[0]} = $a[4];
}
close IN;

open IN, $file1 or die($!);
while (<IN>){
	chomp;
	my @a = split;
	if(exists $gsn{$a[0]}){
		$a[0] = $gsn{$a[0]};
	}else{
		print STDERR "Cound not find gene_short_name for $a[0] at line $. of $file1\n";
	}
	print join "\t", @a;
	print "\n";
}
close IN;



