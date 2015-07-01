#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

=head1

convert_val_to_xresources_colors.pl

Usage ./convert_val_to_xresources_colors.pl [file with values on every line] [ratio] [-n]

Use -s as input to pipe from stdin
Use -n to show the name of the colors (you should input the 18 colors)
Converts values outputed as red, green, blue percentage to xresources colors.

=cut


my $COL_INDEX = 0;
my %COLORS_INDEXES = (
	 0 => "background",
	 1 => "foreground",
	 2 => "color0",
	 3 => "color1",
	 4 => "color2",
	 5 => "color3",
	 6 => "color4",
	 7 => "color5",
	 8 => "color6",
	 9 => "color7",
	 10 => "color8",
	 11 => "color9",
	 12 => "color10",
	 13 => "color11",
	 14 => "color12",
	 15 => "color13",
	 16 => "color14",
	 17 => "color15"
);


sub HELP {
	print "Usage $0 \t [file with values on every line] [ratio] [-n]\n"
	."Converts values outputed as red, green, blue percentage to xresources colors.\n"
	."Use -s as a file for stdin\n"
	."Use -n to show the name of the colors (you should input the 18 colors)\n";
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
	my ($filename, $ratio, $show_name) = @_;
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
		print "*$COLORS_INDEXES{$COL_INDEX}: " if $show_name;
		print "$hexcode\n";
		$COL_INDEX++;
	}
}


sub main {
	my $filename = shift @ARGV;
	my $ratio = shift @ARGV;
	my $show_name = shift @ARGV;
	$show_name = ($show_name && $show_name eq '-n' ? 1 : 0);
	HELP if (!$filename || !$ratio);
	convert_file($filename, $ratio, $show_name);
}


main;
