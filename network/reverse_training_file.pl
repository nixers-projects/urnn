use strict;
use warnings;

=head1
Usage: cat urnn.data | reverse_training_file.pl
=cut

sub HELP {
	print "Usage: cat urnn.data | reverse_training_file.pl\n";
	exit;
}

my $first_line = <stdin>;
HELP unless $first_line;

my ($nb_lines, $nb_inputs, $nb_dataset) = ($first_line =~ /(\d+) (\d+) (\d+)/) or die HELP;
print "$nb_lines $nb_dataset $nb_inputs\n";

#reverse every other 2 lines
while (my $in_line = <stdin>) {
	my $out_line = <stdin>;
	print $out_line;
	print $in_line;
}
