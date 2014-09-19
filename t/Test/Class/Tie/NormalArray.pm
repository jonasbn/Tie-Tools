package Test::Class::Tie::NormalArray;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

#run prior and once per suite
sub startup : Test(startup => 1) {

	use_ok('Tie::NormalArray');

    return 1;
}

sub basic_use : Test(1) {
    my ($self) = @_;
	
	my $tied_array;
	my $scalar;

    ok(tie @$tied_array, 'Tie::NormalArray', $scalar);

    return 1;
}
1;