#!/usr/bin/perl
use strict;
use warnings;

my $note = "the similar function as grep -wf <fileA> <fileB>, but need to specifify the column number";

my $file1 = shift or die("Usage: $0 <fileA> <fileB> <column_fileB>\n$note\n");
my $file2 = shift or die("Usage: $0 <fileA> <fileB> <column_fileB>\n$note\n");
my $column = shift or die("Usage: $0 <fileA> <fileB> <column_fileB>\n$note\n");

my %hash;
open IN, $file1 or die($!);
while (<IN>) {
	chomp;
	$hash{$_} = 1;
}
close IN;

open IN, $file2 or die($!);
while (<IN>) {
	chomp;
	my @a = split /\t/;
	next unless exists $hash{$a[$column-1]};
	print join "\t", @a;
	print "\n";
}
close IN;

