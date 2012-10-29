package OCal::Option;

use Moo;

has type => (
    is       => 'ro',
    isa      => sub { die "CALL/PUT" unless $_[0] =~ /^(CALL|PUT)$/ },
    required => 1,
);

has underlying => ( is => 'ro' );
has strike     => ( is => 'ro', required => 1 );
has expiration => ( is => 'ro' );


sub name {
    my ($self) = @_;

    my @parts = grep { $_ } (
        $self->underlying,
       	lc($self->type),
	$self->strike,
	$self->expiration,
    );
    my $name = join '_', @parts;
    $name =~ s/[^a-zA-Z0-9_]/_/g;

    return $name;
}

sub name_exp {
    my ($self) = @_;

    return $self->name . '_exp';
}

sub to_r {
    my ($self) = @_;

    my $name     = $self->name;
    my $name_exp = $self->name_exp;
    my $strike   = $self->strike;
    my $type     = lc $self->type;

    my $out = <<"EOF";
$name <- EuropeanOptionArrays("$type", S, $strike, 0, 0.01, time_left, vola)
$name_exp <- function(S) {
EOF

    if ($type eq 'call') {
        $out .= "pmax(S - $strike, 0)";
    }
    elsif ($type eq 'put') {
        $out .= "pmax($strike - S, 0)";
    }
    else {
        die "Unknown type: $type";
    }

    $out .= <<"EOF";
}    
EOF

    return $out;
}

1;

