#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

## Author: Qiang Gong <qgong@coh.org>

my ($help,$gint,$gilist,$upc);
my $ref = "/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/hg19/Sequence/WholeGenomeFasta/genome.fa";
GetOptions(
		'fasta=s'    => \$ref,
		'interval=s' => \$gint,
		'list=s'     => \$gilist,
		'upcase!'    => \$upc,
		'help!'      => \$help,
);
&usage if $help;
&usage if ($gint and $gilist);
&usage unless ($gint or $gilist);

my %qchr;
if($gint){
	my ($chrom,$pos1,$pos2) = split /\t/,&getint($gint);
	$qchr{$chrom} .= join "-",$pos1,"$pos2\t";
}else{
	open IN, $gilist, or die($!);
	while (<IN>){
		chomp;
		my ($chrom,$pos1,$pos2) = split /\t/,&getint($_);
		$qchr{$chrom} .= join "-",$pos1,"$pos2\t";
	}
	close IN;
}


my $skip = 1;
my %seq;
my $cur_chr;
open IN, $ref or die($!);
while (<IN>){
	chomp;
	if($_=~s/^>//){
		$cur_chr = $_;
		if(defined $qchr{$cur_chr}){
			$skip = 0;
		}else{
			$skip = 1;
		}
		next;
	}
	next if $skip;
	$seq{$cur_chr} .= $_;
}
close IN;

foreach $cur_chr (sort keys %qchr){
	my @qpos = split /\t/, $qchr{$cur_chr};
	foreach my $cur_pos (@qpos){
		print ">$cur_chr:$cur_pos\n";
		my ($pos1,$pos2) = split /-/,$cur_pos;
		my $seq = substr($seq{$cur_chr},$pos1-1,$pos2-$pos1+1);
		$seq = uc($seq) if $upc;
		while($seq =~ /([ACGTNacgtn]{1,60})/g){
			print "$1\n";
		}
	}
}

sub getint {
	my $ret;
	while ($_[0] =~ /(\S+):(\d+)-(\d+)/g){
		$ret = join "\t",$1,$2,$3;
	}
	$ret;
}


sub usage {
	die(qq/
               Usage 1: get_DNA_seq.pl -i <genomic_interval> [-f <genome.fa>] [-up]
               Usage 2: get_DNA_seq.pl -l <genomic_interval_list> [-f <genome.fa>] [-up]

               Example of genomic interval: chr10:104404615-104404636
			default of genome.fa: \/net\/isi-dcnl\/ifs\/user_data\/jochan\/Group\/qgong\/hg19\/Sequence\/WholeGenomeFasta\/genome.fa
			-up: Output all bases in upper case

\n/);
}
