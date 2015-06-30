#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

=head1

convert_val_to_xresources_colors.pl

Usage ./convert_val_to_xresources_colors.pl [file with values on every line] [ratio]

Use -s as input to pipe from stdin
Converts values outputed as red, green, blue percentage to xresources colors.

=cut


sub HELP {
	print "Usage $0 \t [file with values on every line] [ratio]\n"
	."Converts values outputed as red, green, blue percentage to xresources colors.\n"
	."Use -s as a file for stdin\n";
	exit;
}


sub rgb_to_hex {
	my ($red, $green, $blue, $ratio) = @_;
	my $red_hex = sprintf("%02x", ($red*255)/$ratio);
	my $green_hex = sprintf("%02x", ($green*255)/$ratio);
	my $blue_hex = sprintf("%02x", ($blue*255)/$ratio);
	return "#$red_hex$green_hex$blue_hex";
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
		my ($red, $green, $blue) = $_ =~ m#(\d+(?:\.\d+)?) (\d+(?:\.\d+)?) (\d+(?:\.\d+)?)#;
		my $hexcode = rgb_to_hex($red, $green, $blue, $ratio);
		print "$hexcode\n";
	}
}


sub main {
	my $filename = shift @ARGV;
	my $ratio = shift @ARGV;
	HELP if (!$filename || !$ratio);
	convert_file($filename, $ratio);
}


main;
