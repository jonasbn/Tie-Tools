# test script for Tie::Tools
#
# $Id: test.pl,v 1.3 2003/12/08 21:10:33 jonasbn Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)


my $verbose = 0;

$| = 1; print "1..5\n"; 
foreach (qw(Func Collection Depth NormalArray Parent)) {
    $n++; 
    $loaded = undef;
    eval qq! use Tie::$_; \$loaded = 1; print "ok $n\n";!;
    print "not ok $n\n" unless $loaded;

	print $@ if $@;
}

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

