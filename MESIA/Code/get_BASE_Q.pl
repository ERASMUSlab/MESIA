#!/usr/bin/perl

use strict;
use warnings;

my $standard_down = $ARGV[0];
        chomp $standard_down;

my $standard_up = $ARGV[1];
        chomp $standard_up;

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
        my $value=$preBASEline[8];
		chomp $value;
	if($value>$standard_down){
#		if($value<$standard_up){
			print $preBASEset[$i];
#		}
	}		
}			

