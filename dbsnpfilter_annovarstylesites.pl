#!/usr/bin/perl
use strict;
use warnings;

my $file = shift or die("$0 <output_of_filter> <rsidcolumn>\n");
my $rsfd = shift or die("$0 <output_of_filter> <rsidcolumn>\n");

my $pos=0;
my $rsid;
my $orifd = $rsfd - 4;

open IN, $file or die($!);
while(<>){
	chomp;
	my @a = split;
	if(/^chromo/){
		$rsid = "dbSNP_ID";
		print join "\t",@a[0..$orifd],"$rsid\n";
		next;
	}
	$rsid = "-";
	print join "\t",@a[0..$orifd];
	if($a[1] == $pos){
		print "\t$rsid\n";
		next;
	}
	$pos = $a[1];
	if(@a>$rsfd-3)
	{
		my @mutas = split /,/,$a[$rsfd+1];
		foreach my $muta (@mutas)
		{
			my $lx = length($a[$rsfd]);
			my $ly = length($muta);
			if(
					($lx == $ly && $muta eq $a[4]) ||
					($lx != $ly && ($a[3] eq "-" || $a[4] eq "-"))
			  ) # I do not require the indel share the same allele, which means I filter the indel more strictly
			{
				$rsid = $a[$rsfd-1];
				last;
			}
		}
	}	
	print "\t$rsid\n";
}
close IN;
