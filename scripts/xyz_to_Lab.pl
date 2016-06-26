#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

=head1

xyz_to_Lab.pl

Usage ./xyz_to_Lab.pl <x> <y> <z>

Converts x, y, z (CIE XYZ) to Lab components.

=cut

#White point constant (X, Y, Z)
our @CIEXYZ_D65 = (0.9505, 1.0, 1.0890);

sub HELP {
	print "Usage $0 \t <x> <y> <z>\n".
	"Converts x, y, z (CIE XYZ) to Lab components\n";
	exit;
}


sub Fxyz {
	my ($t) = @_;
	return (
		($t > 0.008856)?
		($t**(1.0/3.0)) :
		(7.787*$t + 16.0/116.0)
	);
}

sub xyz_to_Lab {
	my ($x, $y, $z) = @_;

	my $L = 116.0 * Fxyz( $y/$CIEXYZ_D65[1] ) -16;
	my $A = 500.0 * (Fxyz( $x/$CIEXYZ_D65[0] ) - Fxyz( $y/$CIEXYZ_D65[1] ) );
	my $B = 200.0 * (Fxyz( $y/$CIEXYZ_D65[1] ) - Fxyz( $z/$CIEXYZ_D65[2] ) );

	return ($L, $A, $B);
}



sub main {
	my ($x, $y, $z) = @ARGV;
	HELP if (!$x || !$y || !$z);
	my ($L, $A, $B) =  xyz_to_Lab($x, $y, $z);
	print "$L $A $B";
}


main;
