#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

## Author: Qiang Gong <qgong@coh.org>

my $file = shift or &usage;

my ( $help, $ext, $int_file );
$ext = 10;
GetOptions(
    'extension=i' => \$ext,
    'interval=s'  => \$int_file,
    'help!'       => \$help,
);
&usage if $help;
&usage unless $int_file;
&usage if $file =~ /^-\S+/;

my %itpos;
open IN, $int_file or die($!);
while (<IN>) {
    chomp;
    my ( $c, $p1, $p2 ) = split;
    for ( my $i = $p1 - $ext ; $i <= $p2 + $ext ; $i++ ) {
        my $k = join ":", $c, $i;
        my $v;
        if ( $i > $p2 ) {
            $v = join "", "+", $i - $p2, ",";
        }
        else {
            $v = join "", $i - $p1, ",";
        }
        $itpos{$k} .= $v;
    }
}
close IN;

open IN, $file or die($!);
while (<IN>) {
    chomp;
    my @a = split;
    my $k = join ":", @a[ 0 .. 1 ];
    if ( exists $itpos{$k} ) {
        print join "\t", @a, $itpos{$k};
    }
    else {
        print join "\t", @a, "Out-of-Range";
    }
    print "\n";
}
close IN;

sub usage {
    die(
        qq/
			Usage: probe_pos.pl query.bed(ANNOVAR_style) -i interval_file.bed [-e <int>]

			OPTIONS:
				-e|--extension <int>: bps upstream (-) or downstream (+) of the intervals (default: 10)


\n/
    );
}

