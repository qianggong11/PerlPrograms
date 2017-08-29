#!/usr/bin/perl
use strict;
use warnings;

my $rsof = shift or die("Usage $0 <res_simu_output_file> <cut_possibility>");
my $cutp = shift or die("Usage $0 <res_simu_output_file> <cut_possibility>");

if ($cutp>1 or $cutp<0){
    die("<cut_possibility> should be a value between 0-1;");
}

open RF, $rsof or die($!);
my $ch=0;
my $p1=0;
while (<RF>){
    chomp;
    my @a=split;
    if ($ch != $a[0]){
        $ch=$a[0];
        $p1=0;
    }else{
        if (rand()<=$cutp){
            print $a[1]-$p1,"\n";
            $p1=$a[1];
        }
    }
}




