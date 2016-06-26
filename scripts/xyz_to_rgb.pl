#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

=head1

xyz_to_rgb.pl

Usage ./xyz_to_rgb.pl <x> <y> <z>

inverse of rgb_to_xyz.pl

=cut

sub HELP {
	print "Usage $0 \t <x> <y> <z>\n".
	"Inverse of rgb_to_xyz.pl\n";
	exit;
}


sub xyz_to_rgb {
	my ($x, $y, $z) = @_;

	my @Clinear;
	$Clinear[0] = $x*3.2410 - $y*1.5374 - $z*0.4986; # red
	$Clinear[1] = -$x*0.9692 + $y*1.8760 - $z*0.0416; # green
	$Clinear[2] = $x*0.0556 - $y*0.2040 + $z*1.0570; # blue

	for (my $i=0; $i<3; $i++)
	{
		$Clinear[$i] = ($Clinear[$i]<=0.0031308)? 12.92*$Clinear[$i] : (
			1+0.055)* ($Clinear[$i]**(1.0/2.4)) - 0.055;
	}

	return (
		int($Clinear[0]*255.0),
		int($Clinear[1]*255.0),
		int($Clinear[2]*255.0)
	);
}


sub main {
	my ($x, $y, $z) = @ARGV;
	HELP if (!$x || !$y || !$z);
	my ($r, $g, $b) =  xyz_to_rgb($x, $y, $z);
	print "$r $g $b";
}


main;
