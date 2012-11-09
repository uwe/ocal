#!/usr/bin/env perl

use strict;
use warnings;

use DateTime;
use Statistics::R;


# 30 Put 21-06-13 (29.01)
# 6.10 -> 60.394
# 6.40 -> 63.721

my $expiration = DateTime->new(
	year   => 2013,
	month  => 6,
	day    => 21,
	hour   => 16,
	minute => 0,
	second => 0,
);
# $expiration = $expiration->add(days => 1);

my $today = DateTime->new(
	year   => 2012,
	month  => 11,
	day    => 1,
	hour   => 14,
	minute => 0,
	second => 0,
);
my $next_year = $today->clone->add(years => 1);

my $full_year = $next_year->subtract_datetime_absolute($today);
my $remaining = $expiration->subtract_datetime_absolute($today);

my $maturity = $remaining->seconds / $full_year->seconds;

my $R = Statistics::R->new;

$R->set(type          => 'put');
$R->set(value         => 6.40);
$R->set(underlying    => 29.01);
$R->set(strike        => 30);
$R->set(dividendYield => 0);
$R->set(riskFreeRate  => 0.0025);
$R->set(maturity      => $maturity);
$R->set(volatility    => 0.4);

$R->run(<<"EOF");

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

my $iv = $R->get('iv$impliedVol');

print "IV = $iv\n";

