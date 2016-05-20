#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

=head1

extracter.pl

Usage ./extracter.pl

extract the data from images and colorschemes - still a WIP

=cut


my @images = glob "../inputs/data/*.png";
my @resources = glob "../inputs/data/*.resources";

if (scalar(@images) != scalar(@resources)) {
	print "Not every images has an associated colorscheme";
}

for (my $i = 0; $i < scalar(@images); $i ++) {
	my ($nb) = $images[$i] =~ /(\d+)/;
	my ($nb2) = $resources[$i] =~ /(\d+)/;
	if ($nb ne $nb2) {
		print "There are some stuffs wrong in the inputs directory\n";
		exit 1;
	}
	print "[$nb] Converting colorscheme to specific format\n";
	if (-f "../dataset/$nb.resources.data") {
		qx#rm ../dataset/$nb.resources.data#;
	}
	qx#
		cat $resources[$i] |
		../scripts/extract_hex_from_xresources.pl -s |
		../scripts/convert_hex_to_val_2.pl -s 1 > ../dataset/$nb.resources.data
	#;
	print "[$nb] Extracting 10 most used colors from background\n";
	if (-f "../dataset/$nb.images.data") {
		qx#rm ../dataset/$nb.images.data#;
	}
	#
	# cat $images[$i] |
	# ../convert/convert 30 |
	# sort -k 2 -g -r |
	# cut -d ' ' -f1 |
	# head -n 10 |
	#
	my $result = qx#../colors/sin_colors/colors -pn 10 $images[$i]#;
	my @avail_cols = split /\n/, $result;
	my $num_col_left = 9-scalar(@avail_cols);
	print "Missing $num_col_left colors - adding random ones\n";
	for (0..$num_col_left) {
		my $to_add = int(rand($#avail_cols));
		push @avail_cols, $avail_cols[$to_add];
	}
	my $conv_arg = join "\n",@avail_cols;
	$result = qx#
		echo "$conv_arg" |
		../scripts/convert_hex_to_val_2.pl -s 1 > ../dataset/$nb.images.data
	#;
}
