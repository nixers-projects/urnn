#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

=head1

Lab_to_xyz.pl

Usage ./Lab_to_xyz.pl <L> <A> <B>

Converts L, A, B To xyz (CIE XYZ) components.

=cut

#White point constant (X, Y, Z)
our @CIEXYZ_D65 = (0.9505, 1.0, 1.0890);

sub HELP {
	print "Usage $0 \t <L> <A> <B>\n".
	"Converts L, A, B To xyz (CIE XYZ) components\n";
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

sub Lab_to_xyz {
	my ($l, $a, $b) = @_;

	my $delta = 6.0/29.0;

	my $fy = ($l+16)/116.0;
	my $fx = $fy + ($a/500.0);
	my $fz = $fy - ($b/200.0);

	return (
		($fx > $delta)? $CIEXYZ_D65[0] * ($fx**3) : ($fx - 16.0/116.0)*3*(
			$delta**2)*$CIEXYZ_D65[0],
		($fy > $delta)? $CIEXYZ_D65[1] * ($fy**3) : ($fy - 16.0/116.0)*3*(
			$delta**2)*$CIEXYZ_D65[1],
		($fz > $delta)? $CIEXYZ_D65[2] * ($fz**3) : ($fz - 16.0/116.0)*3*(
			$delta**2)*$CIEXYZ_D65[2]
	);
}



sub main {
	my ($l, $a, $b) = @ARGV;
	HELP if (!defined($l) || !defined($a) || !defined($b));
	my ($x, $y, $z) =  Lab_to_xyz($l, $a, $b);
	print "$x $y $z";
}


main;
