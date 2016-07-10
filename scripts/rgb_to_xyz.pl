#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

=head1

rgb_to_xyz.pl

Usage ./rgb_to_xyz.pl <r> <g> <b>

Converts red, green, blue (over 255) to xyz components.

=cut

sub HELP {
	print "Usage $0 \t <r> <g> <b>\n".
	"Converts rgb colors to XYZ \n";
	exit;
}


sub rgb_to_xyz {
	my ($red, $green, $blue) = @_;

	#normalize red, green, blue values
	my $rLinear = $blue/255.0;
	my $gLinear = $green/255.0;
	my $bLinear = $blue/255.0;

	#convert to a sRGB form
	my $r = ($rLinear > 0.04045)? (
			(($rLinear + 0.055)/( 1 + 0.055))** 2.2) :
			($rLinear/12.92) ;

	my $g = ($gLinear > 0.04045)? (
			(($gLinear + 0.055)/(
			1 + 0.055))** 2.2) :
			($gLinear/12.92) ;

	my $b = ($bLinear > 0.04045)? (
			(($bLinear + 0.055)/(
			1 + 0.055))** 2.2) :
			($bLinear/12.92) ;

	#converts
	return (
		($r*0.4124 + $g*0.3576 + $b*0.1805),
		($r*0.2126 + $g*0.7152 + $b*0.0722),
		($r*0.0193 + $g*0.1192 + $b*0.9505)
	);
}



sub main {
	my ($r, $g, $b) = @ARGV;
	HELP if (!defined($r) || !defined($g) || !defined($b));
	my ($x, $y, $z) =  rgb_to_xyz($r, $g, $b);
	print "$x $y $z";
}


main;

#TEST:
#print Dumper(rgb_to_xyz(255,255,255));
