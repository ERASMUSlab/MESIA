#!/usr/bin/perl

use strict;
use warnings;

my $sample1 = $ARGV[0];
my $sample2 = $ARGV[1];

my @data1 = ();
unless ( open(GET_FILE_sample1, $sample1)){
        print STDERR "Cannot open file \"$sample1\"\n\n";
        exit;}
@data1 = <GET_FILE_sample1>;
close GET_FILE_sample1;

my @data2 = ();
unless ( open(GET_FILE_sample2, $sample2)){
        print STDERR "Cannot open file \"$sample2\"\n\n";
        exit;}
@data2 = <GET_FILE_sample2>;
close GET_FILE_sample2;

#scalar(@data1)
for (my $i=1; $i <scalar(@data1); $i=$i+1){
        my @splitdata1 = split( "\t", $data1[$i]);
	chomp $splitdata1[0];
	my $sample1ID = $splitdata1[0];

	for (my $s=1; $s <scalar(@data2); $s=$s+1){
		my @splitdata2 = split( "\t", $data2[$s]);
		chomp $splitdata2[0];
		my $sample2ID = $splitdata2[0];
		if($sample1ID==$sample2ID){
			print "$data2[$s]";
		}
	}
}

