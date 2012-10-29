package OCal::Position;

use Moo;

has position => ( is => 'ro', default => sub { [] } );

sub add_leg {
    my ($self, $quantity, $leg) = @_;

    push @{$self->position}, [$quantity, $leg];
}

sub to_r {
    my ($self) = @_;

    my $out = <<"EOF";
library(RQuantLib)

S         <- 1950:2400
cur_price <- 2150
time_left <- c(20/365, 10/365, 1/365)
vola      <- 0.3

EOF

    foreach my $pos (@{$self->position}) {
        $out .= $pos->[1]->to_r;
    }

    $out .= 'plot(S, ';
    foreach my $pos (@{$self->position}) {
	$out .= '+' if $pos->[0];
        $out .= $pos->[0] . ' * ' . $pos->[1]->name_exp . '(S) ';
    }
    $out .= ', col="red", type="l", ylab="payoff", ylim=c(-10,50))';

    return $out;
}


1;

