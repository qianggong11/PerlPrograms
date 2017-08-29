#!/usr/bin/perl
use strict;
use warnings;


my $samid;
while (<>){
	chomp;
	my @a=split;
	if ($#a == 0) {
		$samid = $a[0];
#		$samid =~ s/Case.*FL\/Case//g;
		$samid =~ s/\.somatic.snp//g;
		$samid =~ s/\.somatic.indel//g;
		next;
	}
	print join "\t", $samid, @a;
	print "\n";
}

	

