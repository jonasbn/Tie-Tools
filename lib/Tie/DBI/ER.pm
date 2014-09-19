package Tie::DBI::ER;

# $Id: ER.pm 1049 2003-12-08 21:10:33Z jonasbn $

use Tie::DBI;

use strict qw(vars);
use warnings;

use vars qw(@ISA $VERSION);

$VERSION = '1.08';
@ISA = qw(Tie::DBI);

sub TIEHASH {
    my ($class, $hash, $struct) = @_;
    my $self = $class->SUPER::TIEHASH($hash);
    bless $self, $class;
    if (UNIVERSAL::isa($struct, 'HASH') && %$struct) {
        $self->{'struct'} = $struct;
    }
    $self;
}

sub FETCH {
    my ($self, $key) = @_;
    my $val = $self->SUPER::FETCH($key);
    return undef unless ($val);
    my $struct = $self->{'struct'};
    return $val unless ($struct);
    my %stub;
    tie %stub, Tie::DBI::ER::Datum, tied(%$val), $struct;
    \%stub;
}

sub STORE {
    my ($self, $key, $val) = @_;
    my $struct = $self->{'struct'} || {};
    my %hash = %$val;
    foreach (keys %$struct) {
        my $collection = $struct->{$_};
        my $obj = $val->{$_};
        my $index = $obj->{$self->{'key'}};
        $collection->{$index} = $obj # Prevent inifinite loop
            unless ($collection->{$index} == $obj);
        $hash{$_} = $index;
    }
    $self->SUPER::STORE($key, \%hash);
}

package Tie::DBI::ER::Datum;

use vars qw($AUTOLOAD);

sub TIEHASH {
    my ($class, $stub, $struct) = @_;
    bless {'stub' => $stub, 'struct' => $struct}, $class;
}

sub FETCH {
    my ($self, $key) = @_;
    my $val = $self->{'stub'}->FETCH($key);
    my $collection = $self->{'struct'}->{$key};
    $val = $collection->{$val} if (UNIVERSAL::isa($collection, 'HASH'));
    $val;
}

sub STORE {
    my ($self, $key, $val) = @_;
    my $collection = $self->{'struct'}->{$key};
    $val = $val->{$self->{'stub'}->{'key'}} 
		if (UNIVERSAL::isa($collection, 'HASH'));
    $self->{'stub'}->STORE($key, $val);
}

sub AUTOLOAD {
    my $method = (split(/::/, $AUTOLOAD))[-1];
    my $package = substr($AUTOLOAD, 0, -(length($method) + 2));
    my $code = <<EOM;
        package $package;

        sub ${package}::$method {
            my \$self = shift;
            my \$stub = \$self->{'stub'};
            \$stub->$method(\@_);
        }
EOM
    $@ = undef;
    eval $code;
    die $@ if ($@);
    goto &$AUTOLOAD;
}

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

=head2 FETCH

=head2 STORE

=head1 AUTHOR

Ariel Brosh, schop@cpan.org.
B<Tie::Cache> was written by Joshua Chamas, chamas@alumni.stanford.org

=head1 SEE ALSO

perl(1), L<Tie::Cache>.

=head1 COPYRIGHT

Tie::Collection is part of the HTPL package. See L<HTML::HTPL>

=cut
