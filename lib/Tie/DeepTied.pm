package Tie::DeepTied;
require Tie::Hash;

use strict qw(vars subs);
use warnings;
use vars qw(@ISA $VERSION);

$VERSION = '1.08';
@ISA = qw(Tie::Hash);

sub TIEHASH {
    my ($class, $obj, $ind) = @_;
    my $this = {};
    bless $this, $class;
    $this->{'__obj'} = $obj;
    $this->{'__index'} = $ind;
    my $cell = $obj->FETCH($ind);
    $this->{'__storage'} = {%$cell};
    $this;
}

sub STORE {
    my ($this, $key, $value) = @_;
    $this->{'__last'} = time;
    $this->{'__storage'}->{$key} = $value;
    $this->{'__obj'}->STORE($this->{'__index'}, $this->{'__storage'});
    if (UNIVERSAL::isa($value, 'HASH')) {
        unless (tied(%$value)) {
            my %hash = %$value;
            tie %$value, 'Tie::StdHash', $this, $key; # Prevent infinite loop!
            %$value = %hash;
            tie %$value, 'Tie::DeepTied', $this, $key;
        }
    }
}

sub FETCH {
    my ($this, $key) = @_;
    my $value = $this->{'__storage'}->{$key};
    if (UNIVERSAL::isa($value, 'HASH')) {
        unless (tied(%$value)) {
            my %hash = %$value;
            tie %$value, 'Tie::StdHash', $this, $key; # Prevent infinite loop!
            %$value = %hash;
            tie %$value, 'Tie::DeepTied', $this, $key;
        }
    }
    $value;
}

sub DELETE {
    my ($this, $key) = @_;
    delete $this->{'__storage'}->{$key};
}

sub EXISTS {
    my ($this, $key) = @_;
    exists($this->{'__storage'}->{$key});
}

sub CLEAR {
    my $this = shift;
    $this->{'__storage'} = {};
}

sub FIRSTKEY { 
    my $this = shift;
    my $a = scalar keys %{$this->{'__storage'}}; 
    each %{$this->{'__storage'}};
}

sub NEXTKEY { 
    my $this = shift;
    each %{$this->{'__storage'}};
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

=head2 TIEHASH

=head2 STORE

=head2 FETCH

=head2 DELETE

=head2 EXISTS

=head2 CLEAR

=head2 FIRSTKEY

=head2 NEXTKEY

=head1 AUTHOR

Ariel Brosh, schop@cpan.org.
B<Tie::Cache> was written by Joshua Chamas, chamas@alumni.stanford.org

=head1 SEE ALSO

perl(1), L<Tie::Cache>.

=head1 COPYRIGHT

Tie::Collection is part of the HTPL package. See L<HTML::HTPL>

=cut
