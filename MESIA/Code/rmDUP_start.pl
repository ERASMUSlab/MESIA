#!/usr/bin/perl

use strict;
use warnings;

my $RAWbed = $ARGV[0];
my @NEWbed = ();

my @lineRAWbed = ();
unless ( open(GET_FILE_RAWbed, $RAWbed)){
        print STDERR "Cannot open file \"$RAWbed\"\n\n";
        exit;}
@lineRAWbed = <GET_FILE_RAWbed>;
close GET_FILE_RAWbed;

chomp $lineRAWbed[0];
push (@NEWbed,$lineRAWbed[0]);
my $v = scalar(@NEWbed) - 1;

#scalar(@lineRAWbed)
for (my $i=1; $i <scalar(@lineRAWbed); $i=$i+1){
	my $v = scalar(@NEWbed) - 1;
	chomp $lineRAWbed[$i];
	my @splitRAWbed = split( "\t", $lineRAWbed[$i]);
	my @splitNEWbed = split( "\t", $NEWbed[$v]);
		if($splitRAWbed[1] != $splitNEWbed[1]){
			push (@NEWbed,$lineRAWbed[$i]); 
                }
}
for (my $i=0; $i <scalar(@NEWbed); $i=$i+1){
	print "$NEWbed[$i]\n";
}

