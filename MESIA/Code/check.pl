#!/usr/bin/perl

use strict;
use warnings;

my $sample1 = $ARGV[0];

my @data1 = ();
unless ( open(GET_FILE_sample1, $sample1)){
        print STDERR "Cannot open file \"$sample1\"\n\n";
        exit;}
@data1 = <GET_FILE_sample1>;
close GET_FILE_sample1;

my $data1_mean_pvalue = 0;
my $data1_mean_qvalue = 0;
my $data1_mean_score = 0;

#scalar(@data1)
for (my $i=1; $i <scalar(@data1); $i=$i+1){
        my @splitdata1 = split( "\t", $data1[$i]);
	chomp $splitdata1[7];
	chomp $splitdata1[8];
	chomp $splitdata1[9];
	$data1_mean_pvalue = $data1_mean_pvalue + $splitdata1[7];
        $data1_mean_qvalue = $data1_mean_qvalue + $splitdata1[8];
        $data1_mean_score = $data1_mean_score + $splitdata1[9];	
}

$data1_mean_pvalue = $data1_mean_pvalue / scalar(@data1);
$data1_mean_qvalue = $data1_mean_qvalue / scalar(@data1);
$data1_mean_score = $data1_mean_score / scalar(@data1);

print "Mean of pvalue is $data1_mean_pvalue\n";
print "Mean of qvalue is $data1_mean_qvalue\n";
print "Mean of score is $data1_mean_score\n";
