#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

=head1

convert_hex_to_val.pl

Usage ./convert_hex_to_val.pl [file with hexcode on every line] [ratio]

Converts color hex code to red, green, blue percentage over the ratio.

NB: This program shouldn't fail otherwise it might corrupt the training data

=cut


sub HELP {
	print "Usage $0 \t [file with hexcode on every line] [ratio]\n"
	."Converts color hex code to red, green, blue percentage over the ratio.\n"
	."Use -s as a file for stdin\n";
	exit;
}


sub convert_hex_to_ratio {
	my ($hex, $ratio) = @_;
	my $red = -($ratio - ((hex(substr($hex, 0, 1).substr($hex, 1, 1))/255)*2*$ratio));
	my $green = -($ratio - ((hex(substr($hex, 2, 1).substr($hex, 3, 1))/255)*2*$ratio));
	my $blue = -($ratio - ((hex(substr($hex, 4, 1).substr($hex, 5, 1))/255)*2*$ratio));
	return (
		$red,
		$green,
		$blue
	);
}


sub convert_file {
	my ($filename, $ratio) = @_;
	my $fh;
	if ($filename eq '-s') {
		$fh = \*stdin;
	}
	else {
		open($fh, "<", $filename) or die "$!";
	}
	while (<$fh>) {
		chomp;
		$_ =~ s/#//;
		my ($red, $green, $blue) = convert_hex_to_ratio($_, $ratio);
		print "$red $green $blue ";
	}
}


sub main {
	my $filename = shift @ARGV;
	my $ratio = shift @ARGV;
	HELP if (!$filename || !$ratio);
	convert_file($filename, $ratio);
}


main;
