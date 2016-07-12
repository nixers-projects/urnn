#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

=head1

fix_colors.pl

Usage ./fix_colors.pl colors available

Take a number of colors in hexcode and always output 10 colors from those in
their hex value order

=cut

sub HELP {
	print "Usage $0 \t [list of colors]\n"
	."Take a number of colors in hexcode and always output 10 colors from".
	"those in their hex value order\n";
	exit;
}

sub get_lab_values {
	my ($col) = @_;
	my $red = hex(substr($col, 0, 1).substr($col, 1, 1));
	my $green = hex(substr($col, 2, 1).substr($col, 3, 1));
	my $blue = hex(substr($col, 4, 1).substr($col, 5, 1));
	my $result = qx#
		../scripts/rgb_to_xyz.pl $red $green $blue
	#;
	my @xyz_values = split / /, $result;
	$result = qx#
		../scripts/xyz_to_Lab.pl $xyz_values[0] $xyz_values[1] $xyz_values[2]
	#;
	my @Lab_values = split / /, $result;
	return @Lab_values;
}

sub get_hex_from_lab {
	my ($midpoint_x, $midpoint_y, $midpoint_z) = @_;
	my $result = qx#
		../scripts/Lab_to_xyz.pl $midpoint_x $midpoint_y $midpoint_z
	#;
	my @xyz_values = split / /, $result;
	$result = qx#
		../scripts/xyz_to_rgb.pl $xyz_values[0] $xyz_values[1] $xyz_values[2]
	#;
	my @rgb_values = split / /, $result;
	my $red_hex = sprintf("%02x", $rgb_values[0]);
	my $green_hex = sprintf("%02x", $rgb_values[1]);
	my $blue_hex = sprintf("%02x", $rgb_values[2]);
	return "$red_hex$green_hex$blue_hex";
}

sub main {
	my @avail_colors;
	if (scalar(@ARGV) == 1 and $ARGV[0] =~ / /) {
		chomp $ARGV[0];
		@avail_colors = split / /, $ARGV[0];
	}
	else {
		@avail_colors = @ARGV;
	}
	HELP if (scalar(@avail_colors) == 0);
	#remove any '#' char
	for (@avail_colors) {
		$_ =~ s/#//;
	}
	#If there are more than 10 colors, print the first
	if (scalar(@avail_colors) > 10) {
		#truncate the list
		@avail_colors = @avail_colors[0..9];
	}
	else {
		my $nb_missing_colors = 10 - scalar(@avail_colors);

		my $midpoint_x = 0;
		my $midpoint_y = 0;
		my $midpoint_z = 0;
		for my $col (@avail_colors) {
			my @Lab_values = get_lab_values($col);
			$midpoint_x += $Lab_values[0];
			$midpoint_y += $Lab_values[1];
			$midpoint_z += $Lab_values[2];
		}
		$midpoint_x /= scalar(@avail_colors);
		$midpoint_y /= scalar(@avail_colors);
		$midpoint_z /= scalar(@avail_colors);
		my $new_hex = get_hex_from_lab($midpoint_x, $midpoint_y, $midpoint_z);
		while(scalar(@avail_colors) != 10) {
			push @avail_colors, $new_hex;
		}
	}
	$_ = hex($_) for (@avail_colors);
	@avail_colors = sort{$a <=> $b} @avail_colors;
	printf("#%06x ",$_)  for (@avail_colors);
}

main;
