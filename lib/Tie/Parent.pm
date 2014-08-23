package Tie::Parent;

# $Id: Parent.pm 1049 2003-12-08 21:10:33Z jonasbn $

use strict;
use warnings;
use vars qw($VERSION);

$VERSION = '1.07';

sub TIESCALAR {
    my $class = shift;
    my ($obj, $field) = @_;
    my $this = {'obj' => $obj, 'field' => $field};
    bless $this, $class;
}

sub FETCH {
    my $this = shift;
    return $this->{'obj'}->{$this->{'field'}} ||
             $this->{'obj'}->{uc($this->{'field'})} ||
             $this->{'obj'}->{lc($this->{'field'})};
}

sub STORE {
    my ($this, $value) = @_;
    $this->{'obj'}->{$this->{'field'}} = $value;
}

1;
