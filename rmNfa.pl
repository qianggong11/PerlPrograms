#!/usr/bin/perl
use strict;
use warnings;

## This script remove sequences containing N from FASTA files

my $file = shift or die("Usage: $0 <*.fa>");

my $name;
open IN, $file or die($!);
while(<IN>){
	chomp;
	if(/>.*/){
		$name=$_;
	}elsif(/N/){
		next;
	}else{
		print "$name\n$_\n";
	}
}
close IN;
	
