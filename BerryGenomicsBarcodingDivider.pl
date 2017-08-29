#!/usr/bin/perl
use strict;
use warnings;
## Dividing the fastq files produced by BerryGenomics
## Contact: gongqiang.big@gmail.com

my $file = shift or die("Usage: $0 <fq>/<fq.gz>");
my @barcodes=qw/GCCAAT CTTGTA CGATGT/;
open OT0, "| gzip >$barcodes[0].$file";
open OT1, "| gzip >$barcodes[1].$file";
open OT2, "| gzip >$barcodes[2].$file";
open OTX, "| gzip >Unrecognized.$file";

if ($file =~ /\.gz$/) {
	open(IN, "gzip -cd $file |") or die "can't open pipe to $file";
}
else {
	open(IN, $file) or die "can't open $file";
}

my $id;
my $idcount=0;
my $read;
while (<IN>) {
	$idcount++;
	chomp($id=$_);
	$read=<IN>;
	$read.=<IN>;
	$read.=<IN>;
	if($id=~/^\@HWI.*$barcodes[0]([ATCGN]{8})$/){
		$id="\@read:".$idcount.":$1\n";
		select OT0;
	}elsif($id=~/^\@HWI.*$barcodes[1]([ATCGN]{8})$/){
		$id="\@read:".$idcount.":$1\n";
		select OT1;
	}elsif($id=~/^\@HWI.*$barcodes[2]([ATCGN]{8})$/){
		$id="\@read:".$idcount.":$1\n";
		select OT2;
	}elsif($id=~/^\@HWI.*([ATCGN]{6})([ATCGN]{8})$/){
		$id="\@read:".$idcount.":$1:$2\n";
		select OTX;
	}
	print $id,$read;
}
close IN;
close OT0;
close OT1;
close OT2;
close OTX;



