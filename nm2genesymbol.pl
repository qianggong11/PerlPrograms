#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;


my $reflink = "/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/hg19reflink.txt";
my ($nmf,$help);
my $file = shift or &usage;

GetOptions(
		'field=i' => \$nmf,
		'reflink=s' => \$reflink,
		'help!'	=> \$help,
);

&usage if $help;
&usage if $file =~ /^-\S+/;

my %gsym;
open IN, $reflink or die($!);
while (<IN>){
	chomp;
	my @a = split;
	next if @a < 6;
	my $gs = $a[0];
	foreach my $id (@a[1..$#a]){
		$gsym{$id} = $gs if $id =~ /^N[MPR]_\d+/;
	}
}
close IN;

open IN, $file or die($!);
while (<IN>){
	chomp;
	my @a = split;
	print join "\t",@a,&transform($a[$nmf-1]);
	print "\n";
}
close IN;

sub transform {
	my @ids = split /,/,$_[0];
	my @rtns;
	foreach my $id (@ids){
		next unless $id =~ /^N[MPR]_\d+/;
		if(exists $gsym{$id}){
			push @rtns, $gsym{$id};
		}else{
			push @rtns, "UnknownGene";
		}
	}
	if(@rtns>0){join ",", @rtns;}else{"-";}
}

sub usage {
	die(qq/
USAGE: nm2genesymbol.pl <input_files> -f <NM-id-field(int)> [-r <reflink_file>]
	The default reflink file: \/net\/isi-dcnl\/ifs\/user_data\/jochan\/Group\/qgong\/hg19\/hg19reflink.txt

\n/);
}
