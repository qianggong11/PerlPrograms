#!/usr/bin/perl
use strict;
use warnings;

my $ref = shift or die("Usage: $0 <ref_file> <length> <number of fragments>");
my $fl=shift or die("Usage: $0 <ref_file> <length> <number of fragments>");
my $num = shift or die("Usage: $0 <ref_file> <length> <number of fragments>");

open RF, $ref or die($!);
my $seq;
while (<RF>){
    chomp;
    if ($_=~/>.*/){
        next;
    }else{
        $seq.=$_;
    }
}

my $size = length($seq);
my $size_unit=$size/$num;

for(my $i=0;$i<$num;$i++){
    print substr($seq,rand($size_unit),$fl),"\n";
    substr($seq,0,$size_unit)="";
}


