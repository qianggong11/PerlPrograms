#!/usr/bin/perl
use strict;
use warnings;

my $file = shift or &usage;
my $newo = shift or &usage;


open IN, $file;
while (<IN>){
	chomp;
	my @a = split;
	my @idx = &odseq($newo,$#a+1);
	for(my $i=0;$i<$#idx;$i++){print "$a[$idx[$i]]\t";}
	print "$a[$idx[$#idx]]\n";
}
close IN;

sub odseq{
	my @seqels = split /,/,$_[0];
	my @r;
	foreach my $el (@seqels){
		if($el=~/(\d+)-(\d+)/){
			&out_range if($1>$_[1] or $2>$_[1]);
			if ($1<$2){
				for(my $i=$1;$i<=$2;$i++){push @r, $i-1;}
			}else{
				for(my $i=$1;$i>=$2;$i--){push @r, $i-1;}
			}
		}elsif($el=~/(\d+)-/){
			&out_range if $1>$_[1];
			for(my $i=$1;$i<=$_[1];$i++){push @r,$i-1;}
		}elsif($el=~/(\d+)/){
			&out_range if $1>$_[1];
			push @r,$1-1;
		}else{
			print "Wrong format of <new_orders>: $_[0]\n\n";
			&usage;
		}
	}
	return @r;
}

sub out_range {
	print "Contain numbers out of range\n\n";
	&usage;
}

sub usage{
	die(qq/
USAGE: reorder_columns.pl <tab-delimited file> <new_orders>
	Example format of <new_orders>:
		
		9,5,2,7
		5-9,2-7
		9-5,2-7
		1-9,1-5,5-1
		9-,5,2,7

\n/);
}
