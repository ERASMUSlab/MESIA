#!/usr/bin/perl

use strict;
use warnings;

my $qvalue_cutdoff = $ARGV[0];
        chomp $qvalue_cutdoff;

my $PP_cutdoff = $ARGV[1];
        chomp $PP_cutdoff;

my $preBASE = $ARGV[2];

my @preBASEset = ();
unless ( open(GET_FILE_preBASE, $preBASE)){
        print STDERR "Cannot open file \"$preBASE\"\n\n";
        exit;}
@preBASEset = <GET_FILE_preBASE>;
close GET_FILE_preBASE;

#scalar(@preBASEset)
for (my $i=0; $i <scalar(@preBASEset); $i=$i+1){
        my @preBASEline = split( "\t", $preBASEset[$i]);
        my $qvalue=$preBASEline[8];
		chomp $qvalue;
        my $PP=$preBASEline[9];
                chomp $PP;
	if($PP>$PP_cutdoff){
		if($qvalue>$qvalue_cutdoff){
			print $preBASEset[$i];
		}
	}		
}			

