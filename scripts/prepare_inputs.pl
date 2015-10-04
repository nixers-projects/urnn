#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

=head1

prepare_inputs.pl

Usage ./prepare_inputs.pl

Prepare the input for the neural network training - still a WIP

=cut

my @images = glob "../dataset/*.images.data";
my @resources = glob "../dataset/*.resources.data";
my $number_of_inputs = 0;
my $final_string = "";

if (scalar(@images) != scalar(@resources)) {
	print "Not every images data has an associated colorscheme data";
}


for (my $i = 0; $i < scalar(@images); $i ++) {
	my ($nb) = $images[$i] =~ /(\d+)/;
	my ($nb2) = $resources[$i] =~ /(\d+)/;
	if ($nb ne $nb2) {
		print STDERR "There are some stuffs wrong in the dataset dir\n";
		exit 1;
	}
	my $nb_col = qx#cat $images[$i] | xargs -n3 | wc -l#;
	print STDERR "[$nb]: \n";
	if ($nb_col == 10) {
		$number_of_inputs++;
		$final_string .= qx# cat $images[$i] # . "\n";
		$final_string .= qx# cat $resources[$i] # . "\n";
	}
	else {
		print STDERR "Colorscheme file doesn't have 10 colors -> skipping\n";
	}
}
$final_string = "$number_of_inputs 30 54\n". $final_string;
print $final_string;
