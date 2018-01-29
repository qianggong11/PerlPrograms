#!/usr/bin/perl
use strict;
use warnings;

my $file1 = shift or die("Usage: $0 <site_list> <reference.fa>");
my $file2 = shift or die("Usage: $0 <site_list> <reference.fa>");

my %ref;
my $c;
open IN, $file2 or die($!);
while(<IN>){
    chomp;
    if(/>\S+/){
        $c=substr($_,1);
    }else{
        $ref{$c}.=$_;
    }
}
close IN;

print "SNP_ID\tSequence\n";
open IN, $file1 or die($!);
while(<IN>){
    chomp;
    my @a=split;
    my $o=substr($ref{$a[0]},$a[1]-211,210);
    $o.="["."$a[2]/$a[3]"."]";
    $o.=substr($ref{$a[0]},$a[1],210);
    print "$a[0]_$a[1]\t$o\n";
}
close IN;

### Example for <site_list> ###

# chr22   30484519    A   G
# chr2    109958426   T   C
# chrX    46825681    A   C
# chr15   51794759    A   C
# chr2    47495006    T   C
# chr6    167674131   A   G
# chr4    165337910   A   G
# chr14   49332283    C   G
# chrM    3883    G   A
# chr15   41495816    A   C
# chr11   65523418    T   C
# chr9    20966413    T   G
# chr11   77089553    T   C
# chr18   12442506    A   C
# chr3    199076723   A   C
# chr1    194663994   T   C
# chr15   22861402    A   C
# chr21   27135178    A   G
# chr1    42996159    A   C
# chr7    102083879   C   T
# chr1    104035517   T   C
# chr1    104035521   A   C
# chr2    162735720   G   T
# chr16   14727588    A   C
# chr16   15365077    A   G
