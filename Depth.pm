package Tie::Depth;
require Tie::Hash;

@ISA = (Tie::Hash);

sub TIEHASH {
    my ($class, $obj, $ind) = @_;
    my $this = {};
    bless $this, $class;
    $this->{'__obj'} = $obj;
    $this->{'__index'} = $ind;
    my $cell = $obj->{$ind};
    $this->{'__storage'} = {%$cell};
    $this;
}

sub STORE {
    my ($this, $key, $value) = @_;
    $this->{'__last'} = time;
    $this->{'__storage'}->{$key} = $value;
    if (UNIVERSAL::isa($value, 'HASH')) {
        unless (tied(%$value)) {
            tie %$value, __PACKAGE__, $this, $key;
        }   
    }
    $self->{'__obj'}->{$self->{'__index'}} = $this->{'__storage'};
}

sub FETCH {
    my ($this, $key) = @_;
    $this->{'__storage'}->{$key};
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
