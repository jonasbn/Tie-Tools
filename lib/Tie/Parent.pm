package Tie::Parent;

# $Id: Parent.pm 1049 2003-12-08 21:10:33Z jonasbn $

use strict;
use warnings;
use vars qw($VERSION);

$VERSION = '1.08';

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

__END__

=head1 NAME

Tie::Collection - A trivial implementaion of Tie::Cache by using a tied
handle of a hash for storage.

=head1 SYNOPSIS

use Tie::Collection;
use DB_File;
use Fcntl;

$dbm = tie %hash2, DB_File, 'file.db', O_RDWR | O_CREAT, 0644;
tie %hash, Tie::Collection, $dbm, {MaxBytes => $cache_size};

=head1 DESCRIPTION

Tie::Collection implements a trivial implementation of B<Tie::Cache> by 
Joshua Chamas, that gets a tied hash handle to store the data. Assumption
was that most common use will be disk storage, therfore the storage hash
will probably be tied.

Tie::Collection is useful with B<DB_File> or B<MLDBM>, as will as with
B<Tie::DBI>. It was designed to be used with B<HTML::HTPL> in order to
cache objects accesses via a key, so they don't have to be read from disk
again and again.

Tie::Collection needs two parameters: The handled of the tied hash, and a
hashref with parameters to pass to B<Tie::Cache>. (See manpage).

=head1 SUBROUTINES/METHODS

=head2 TIESCALAR

=head2 FETCH

=head1 STORE

=head1 AUTHOR

Ariel Brosh, schop@cpan.org.
B<Tie::Cache> was written by Joshua Chamas, chamas@alumni.stanford.org

=head1 SEE ALSO

perl(1), L<Tie::Cache>.

=head1 COPYRIGHT

Tie::Collection is part of the HTPL package. See L<HTML::HTPL>

=cut
