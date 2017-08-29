#!/usr/bin/perl
use strict;
use warnings;

my $seq=shift or die("Usage: $0 <your_sequence>");


my @a=split //, $seq;
my @b;
foreach (@a){
    unshift @b, &comp($_);
}
foreach (@b){
    print $_;
}
print "\n";

sub comp {
    if(/[Aa]/){
        return "T";
    }elsif(/[Cc]/){
        return "G";
    }elsif(/[Gg]/){
        return "C";
    }elsif(/[Tt]/){
        return "A";
    }elsif(/[Rr]/){
        return "Y";
    }elsif(/[Yy]/){
        return "R";
    }elsif(/[Mm]/){
        return "K";
    }elsif(/[Kk]/){
        return "M";
    }elsif(/[Ss]/){
        return "S";
    }elsif(/[Ww]/){
        return "W";
    }elsif(/[Hh]/){
        return "D";
    }elsif(/[Dd]/){
        return "H";
    }elsif(/[Bb]/){
        return "V";
    }elsif(/[Vv]/){
        return "B";
    }elsif(/[Nn]/){
        return "N";
    }elsif(/-/){
        return "-";
    }else{
        return "*";
    }
}




