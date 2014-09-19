package Tie::NormalArray;

use strict;
use warnings;
use vars qw($VERSION);

$VERSION = '1.08';

sub TIEARRAY {
    my ($class, $shadow) = @_;
    my $self = bless {'shadow' => $shadow}, $class;
    $self->size;
    $self;
}

sub FETCH {
    my ($self, $index) = @_;
    $self->{'shadow'}->FETCH($index);
}

sub STORE {
    my ($self, $index, $value) = @_;
    my $flag = $self->{'shadow'}->EXISTS($index);
    $self->{'shadow'}->STORE($index, $value);
    $self->{'size'}++ unless ($flag);
}

sub DESTROY {
    my $self = shift;
    undef $self->{'shadow'};
}

sub size {
    my $self = shift;
    my $size = 0;
    my $obj = $self->{'shadow'};
    my ($k, $v) = $obj->FIRSTKEY;
    my %hash;
    $hash{int($k)} = 1;
    while (($k, $v) = $obj->NEXTKEY) {
        $hash{int($k)} = 1;
    }
    my @keys = sort {$b <=> $a} keys %hash;
    $self->{'size'} = $keys[0] + 1;
}

sub FETCHSIZE {
    my $self = shift;
    $self->{'size'};
}

sub STORESIZE {
    my ($self, $size) = @_;
    my $current = $self->FETCHSIZE;
    while ($current < $size) {
        $self->STORE($current++, undef);
    }
    while ($current > $size) {
        $self->{'shadow'}->DELETE(--$current);
    }
    $self->{'size'} = $size;
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

=head2 TIEARRAY

=head2 FETCH

=head2 STORE

=head2 DESTROY

=head2 size

=head2 FETCHSIZE

=head2 STORESIZE

=head1 AUTHOR

Ariel Brosh, schop@cpan.org.
B<Tie::Cache> was written by Joshua Chamas, chamas@alumni.stanford.org

=head1 SEE ALSO

perl(1), L<Tie::Cache>.

=head1 COPYRIGHT

Tie::Collection is part of the HTPL package. See L<HTML::HTPL>

=cut

