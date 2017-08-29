#!/usr/bin/perl -w
#
use warnings;
use strict;

my $db_file  = shift or die("Usage: $0 <fasta_file> <seq_name>\n");
my $seq_name = shift or die("Usage: $0 <fasta_file> <seq_name>\n");

open(IN, $db_file) or die($!);
my $flag = 0;
while(<IN>){
	if(/^>(\S+)/){
		last if($flag);
		$flag = 1 if($1 eq $seq_name);
	}
	print if($flag);
}
close IN;
