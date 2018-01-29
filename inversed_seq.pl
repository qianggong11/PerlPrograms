#!/usr/bin/perl
use strict;
use warnings;

my $input = shift or die("Usage $0 <input_sequence");

print &invseq($input),"\n";


sub invseq {
	my @a=split //, $_[0];
	my $iseq;
	my $base;
	while ($a[0]){
		$base=pop @a;
		$base = uc($base);
		if($base eq "A"){
			$base="T";
		}elsif($base eq "T"){
			$base="A";
		}elsif($base eq "C"){
			$base="G";
		}elsif($base eq "G"){
			$base="C";
		}
		$iseq.=$base;
	}
	return $iseq;
}



