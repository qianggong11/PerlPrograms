#!/usr/bin/perl -w
#
use warnings;
use strict;

my $db_file  = shift or die("Usage: $0 <fasta_file> <seq_order>\n");
my $seq_order = shift or die("Usage: $0 <fasta_file> <seq_order>\n");

open(IN, $db_file) or die($!);
my $flag = 0;
my $n=0;
while(<IN>){
	if(/^>\S+/){
		$n++;
		last if($flag);
		$flag = 1 if($n == $seq_order);
	}
	print if($flag);
}
close IN;
