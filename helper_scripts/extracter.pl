#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

=head1

wrapper.pl

Usage ./wrapper.pl

extract the data from images and colorschemes - still a WIP

=cut


my @images = glob "../images/*.png";
my @resources = glob "../images/*.resources";

if (scalar(@images) != scalar(@resources)) {
	print "Not every images has an associated colorscheme";
}

for (my $i = 0; $i < scalar(@images); $i ++) {
	my ($nb) = $images[$i] =~ /(\d+)/;
	my ($nb2) = $resources[$i] =~ /(\d+)/;
	if ($nb ne $nb2) {
		print "There are some stuffs wrong in the images directory\n";
		exit 1;
	}
	print "[$nb]: \n";
	print "Converting colorscheme to specific format\n";
	qx#
		cat $resources[$i] |
		../helper_scripts/extract_hex_from_xresources.pl -s |
		../helper_scripts/convert_hex_to_val.pl -s 1 > ../outputs/$nb.resources.data
	#;
	print "Extracting 10 most used colors from background\n";
	qx#
		cat $images[$i] |
		../convert/convert 30 |
		sort -k 2 -g -r |
		cut -d ' ' -f1 |
		head -n 10 |
		../helper_scripts/convert_hex_to_val.pl -s 1 > ../outputs/$nb.images.data
	#;
}
