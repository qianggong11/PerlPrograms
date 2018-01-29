#!/usr/bin/perl -w
use strict;

my $ncol = 8;

my $i = 0;
while (<>){
	chomp;
	$i++;
	print $_;
	if ($i % $ncol == 0) {
		print "\n";
	}else{
		print "\t";
	}
}

print "\n";
