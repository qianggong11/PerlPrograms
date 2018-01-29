#!/usr/bin/perl
use strict;
use warnings;

my $common_SNP_cutoff = 0.01;
my $gene_panel_file = "/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/GenePanel/AgilentPanel.noZNF717andCTBP2.txt";

my $pfx = shift or die("Usage: $0 <prefix>
	Note: Only works on *.hg19_multianno.txt from somaticID.pl
	      Only report non-silent mutations
		  Exclude common SNPs (>1%)\n");

my %panel_genes;
open IN, $gene_panel_file or die($!);
while (<IN>){
	chomp;
	$panel_genes{$_} = 1;
}
close IN;

my $files = `ls $pfx*hg19_multianno.txt`;
my @header = qw(Chr Pos Ref Alt Gene AAC MutType dbSNP PopFreq CADD_phred Comic ClinVar);
foreach my $f (split /\n/, $files){
	&vartable($f);
}

sub vartable {
	open IN, $_[0] or die($!);
	while (<IN>){
		chomp;
		my @a = split /\t/;
		next if $a[0] eq "Chr";
		my $n_sample = $#a - 64;
		if( @header == 12 ){
			for (my $i=1; $i<= $n_sample; $i++){
				push @header, ("Sample$i.Ref","Sample$i.Var","Sample$i.VAF");
			}
			print join "\t", @header;
			print "\n";
		}
		print STDERR "WARNING: Unexpected column number:\n$_\n" 
			if $#header - 11 < $n_sample * 3;
		next unless $a[5] =~ /^exonic|^splicing|;exonic|;splicing/;
		next if $a[11] ne "." and $a[11] > $common_SNP_cutoff;
		next if $a[8] =~ /^synonymous|^unknown/;
		$a[8] = $a[5] if $a[8] eq ".";
		$a[8] =~ s/ /_/g;
		my $gene = $a[6];
		my $aac = ".";
		unless($a[9] eq "."){
			my @pcs = split /,/, $a[9];
			my $aap = 0;
			foreach my $pc (@pcs){
				my @p = split /:/, $pc;
				if($pc =~ /:p\.\D*(\d+)\D/){
					my $cp = $1;
					next unless $cp > $aap;
					$aap = $cp;
					$aac = $p[4];
					$gene = $p[0];
				}else{
					print STDERR "WARNING: Cannot get amino acid changing information from $pc\n";
					$aac = $pc;
				}
			}
		}
		next unless exists $panel_genes{$gene};   # using a white list to screening out mapping-error-induced FPs
		my @rdout;
		foreach my $rd (@a[65..$#a]){
			my @ds = split /:/, $rd;
			if(@ds == 14){
				push @rdout, join "\t", @ds[4..6];
			}else{
				push @rdout, join "\t", ".";
			}
		}
		print join "\t", @a[0,1,3,4], $gene, $aac, @a[8,15,11,34,14,13], @rdout;
		print "\n";
	}
	close IN;
}






		
