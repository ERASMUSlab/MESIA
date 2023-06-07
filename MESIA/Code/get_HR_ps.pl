#!/usr/bin/perl

use strict;
use warnings;

my $psQ3 = $ARGV[0];
	chomp $psQ3;

my $HR = $ARGV[1];

my @preHRset = ();
unless ( open(GET_FILE_HR, $HR)){
        print STDERR "Cannot open file \"$HR\"\n\n";
        exit;}
@preHRset = <GET_FILE_HR>;
close GET_FILE_HR;


#scalar(@preHRset)
for (my $i=0; $i <scalar(@preHRset); $i=$i+1){
        my @preHRline = split( "\t", $preHRset[$i]);
        my $ps=$preHRline[9];
		chomp $ps;
	if($ps>$psQ3){
		print $preHRset[$i];
	}
}

