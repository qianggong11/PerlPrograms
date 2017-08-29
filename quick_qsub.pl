#!/usr/bin/perl -w
# Author: Ruan Jue <ruanjue@gmail.com>
#
## Example: ./quick_qsub.pl [=job1=] {-l nodes=1:ppn=8} $'asda'\sdas\'das$$d | kkk ... *** > 5345'
use warnings;
use strict;

my $queue = 'all.q';
my $cmd = '';

if(@ARGV){
	$cmd = join(" ", @ARGV);
} else {
	while(<>){
		$cmd .= $_;
	}
}

die(qq{Usage: $0 [=<job_name>=] [\{qsub parameters\}] command\n}) unless($cmd);

chomp $cmd;

my $name = undef;
if($cmd =~/^=(\S+)=/){
	$name = $1;
	$cmd = substr($cmd, length($name) + 2);
	$cmd =~s/^\s+//;
}
my $qsub_param = '';
if($cmd =~/^{(.+?)}\s/){
	$qsub_param = $1;
	$cmd = substr($cmd, length($qsub_param) + 3);
	$cmd =~s/^\s+//;
}

my $pwd = `pwd`;
chomp $pwd;
my $home = $ENV{HOME};
if(not defined $name){
	$name = $cmd;
	while($name=~s/\/[^ \/\t]+\//\//){}
	$name =~s/^\.*\///;
	$name =~s/[^a-z0-9A-Z_\-]+/_/g;
	$name = substr($name, 0, 15);
}

my $cmd_str = $cmd;
$cmd_str =~s/'/\\\'/g;
$cmd_str = "'$cmd_str'";

my $history = "$pwd/qsub.history";
if(not -d $history){
	system("mkdir $history") and die("Cannot create $history: $!");
}

open(OUT, ">$history/qsub.cmd.$name.$$.sh") or die($!);
print OUT qq{#!/bin/bash
#\$ -N $name
#\$ -o $history/qsub.log.$name.$$
#\$ -e $history/qsub.err.$name.$$
#\$ -q $queue
#\$ -cwd
#\$ -V
#\$ -M qgong\@coh.org
#\$ -m as
# qsub parameter: "$qsub_param"
uname -a
cd $pwd
date
echo "job: $name"
echo \$$cmd_str
$cmd
date
};
close OUT;

exit if($ENV{NO_QSUB});

my $job_id = `qsub $qsub_param $history/qsub.cmd.$name.$$.sh`;
chomp $job_id;
my $date = `date`;
chomp $date;
$job_id=~/(\d+)/;
print "[$pwd] $cmd\njob_id: $1\n";

open(OUT, ">>$home/quick_qsub.history") or die($!);
print OUT qq{[$pwd $date $job_id]: $cmd\n};
close OUT;

1;
