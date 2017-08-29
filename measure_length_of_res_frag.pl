#!/usr/bin/perl
use strict;
use warnings;

my $cutting_file=shift or die("Usage: $0 <cutting_result_file> <read_list_file> <mismatch_read_file>\n");
my $read_list=shift or die("Usage: $0 <cutting_result_file> <read_list_file> <mismatch_read_file>\n");
my $mis1_file=shift or die("Usage: $0 <cutting_result_file> <read_list_file> <mismatch_read_file>\n");


my %read_count;
my %mis;

open MF, $mis1_file or die($!);
while (<MF>){
	chomp;
	my @a=split;
	$mis{$a[1]}=$a[0];
}
close MF;

open RL, $read_list or die($!);
while(<RL>){
	chomp;
	if($mis{$_}){
		$read_count{$mis{$_}}++;
		$read_count{$_}=$read_count{$mis{$_}};
	}else{
		$read_count{$_}++;
	}
}
close RL;

my $skip_count=0;
my $length=1;
my $start=0;
my $curr_chr=0;
open CF, $cutting_file or die($!);
while (<CF>){
	chomp;
	my @a=split;
	if ($curr_chr!=$a[0]){
		print "$curr_chr\t$skip_count\t$start\t",$start+$length,"\t$length\n";
		$skip_count=0;
		$length=1;
		$curr_chr=$a[0];
		$start=0;
	}else{
		if ($read_count{$a[2]}>1){
			print "$curr_chr\t$skip_count\t$start\t$a[1]\t",$a[1]-$start,"\n";
			$skip_count=0;
			$length=1;
			$start=$a[1];
		}else{
			$skip_count++;
			$length=$a[1]-$start;
		}
		if ($read_count{$a[5]}>1){
			print "$curr_chr\t$skip_count\t$start\t$a[4]\t",$a[4]-$start,"\n";
			$skip_count=0;
			$length=1;
			$start=$a[4];
		}else{
			$length=$a[1]-$start;
		}
	}
}
close CF;






