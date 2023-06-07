#!/usr/bin/perl

use strict;
use warnings;

my $SV_cutdoff = $ARGV[0];
        chomp $SV_cutdoff;

my $qvalue_cutdoff = $ARGV[1];
        chomp $qvalue_cutdoff;

my $PP_cutdoff = $ARGV[2];
        chomp $PP_cutdoff;

my $preBASE = $ARGV[3];

my @preBASEset = ();
unless ( open(GET_FILE_preBASE, $preBASE)){
        print STDERR "Cannot open file \"$preBASE\"\n\n";
        exit;}
@preBASEset = <GET_FILE_preBASE>;
close GET_FILE_preBASE;

#scalar(@preBASEset)
for (my $i=0; $i <scalar(@preBASEset); $i=$i+1){
        my @preBASEline = split( "\t", $preBASEset[$i]);
        my $SV=$preBASEline[6];
                chomp $SV;
        my $qvalue=$preBASEline[8];
		chomp $qvalue;
        my $PP=$preBASEline[9];
                chomp $PP;
	if($PP>$PP_cutdoff){
		if($qvalue>$qvalue_cutdoff){
			if($SV>$SV_cutdoff){
				print $preBASEset[$i];
			}
		}
	}		
}			

