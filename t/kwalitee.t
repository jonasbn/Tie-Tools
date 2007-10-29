# $Id$

#Courtesy of chromatic
#http://search.cpan.org/~chromatic/Test-Kwalitee/lib/Test/Kwalitee.pm

use strict;
use Test::More;

eval { require Test::Kwalitee; Test::Kwalitee->import() };

plan( skip_all => 'Test::Kwalitee not installed; skipping' ) if $@;
