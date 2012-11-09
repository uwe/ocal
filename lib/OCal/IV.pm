package OCal::IV;

# calculate implied volatility

use Moo;

use DateTime;
use Scalar::Util qw/blessed/;
use Statistics::R;


# required parameters
has expiration     => (is => 'ro', required => 1);
has today          => (is => 'ro', required => 1);
has risk_free_rate => (is => 'ro', required => 1);

# default parameters
has type           => (is => 'ro');
has value          => (is => 'ro');
has underlying     => (is => 'ro');
has strike         => (is => 'ro');
has dividend_yield => (is => 'ro');

# internal parameters
has maturity => (is => 'lazy');
has r_bridge => (is => 'lazy');

sub iv {
	my ($self, %arg) = @_;

	my $type           = $arg{type}           || $self->type           || die "Type missing";
	my $value          = $arg{value}          || $self->value          || die "Value missing";
	my $underlying     = $arg{underlying}     || $self->underlying     || die "Underlying missing";
	my $strike         = $arg{strike}         || $self->strike         || die "Strike missing";
	my $dividend_yield = $arg{dividend_yield} || $self->dividend_yield || 0;

	my $R = $self->r_bridge;

	$R->set(type => $type);
	$R->set(value => $value);
	$R->set(underlying => $underlying);
	$R->set(strike     => $strike);
	$R->set(dividendYield => $dividend_yield);
	$R->set(riskFreeRate  => $self->risk_free_rate);
	$R->set(maturity      => $self->maturity);
	$R->set(volatility    => 0.4);

	$R->run(<<'EOF');
library(RQuantLib);

iv <- AmericanOptionImpliedVolatility(
	type          = type,
	value         = value,
	underlying    = underlying,
	strike        = strike,
	dividendYield = dividendYield,
	riskFreeRate  = riskFreeRate,
	maturity      = maturity,
	volatility    = volatility
)
EOF

	return $R->get('iv$impliedVol');
}


sub _build_maturity {
	my ($self) = @_;

	my $expiration = $self->_convert_date($self->expiration);
	my $today      = $self->_convert_date($self->today);

	my $next_year  = $today->clone->add(years => 1);

	my $full_year  = $next_year->subtract_datetime_absolute($today);
	my $remaining  = $expiration->subtract_datetime_absolute($today);

	return $remaining->seconds / $full_year->seconds;
}

sub _build_r_bridge {
	return Statistics::R->new;
}

sub _convert_date {
	my ($self, $date) = @_;

	return $date if blessed $date;

	if ($date =~ /^(\d\d\d\d)-(\d\d)-(\d\d)$/) {
		return DateTime->new(
			year   => $1,
			month  => $2,
			day    => $3,
			hour   => 16,
			minute => 0,
			second => 0,
		);
	}

	die "Unknown date format: $date";
}

1;

