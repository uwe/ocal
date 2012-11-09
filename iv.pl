#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';
use OCal::IV;


my $iv = OCal::IV->new(
	risk_free_rate => 0.0025,
	expiration     => '2013-06-21',
	today          => '2012-11-01',
	underlying     => 29.01,
	strike         => 30,
	type           => 'put',
);

foreach my $value ((6.10, 6.40)) {
	printf(
		"%.2f -> %.3f\n",
		$value,
		100 * $iv->iv(value => $value),
	);
}

