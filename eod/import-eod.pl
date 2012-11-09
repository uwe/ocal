#!/usr/bin/env perl

use strict;
use warnings;

use File::Path  qw/make_path/;
use File::Slurp qw/append_file/;


local $| = 1;

my $input_path  = 'C:/eoddata3/NASDAQ/';
my $output_path = 'C:/quotes/';


my @month = qw/xxx Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;

foreach my $file (sort glob($input_path . '*.csv')) {
	unless ($file =~ m#/(AMEX|NASDAQ|NYSE)_(\d{8}).csv$#) {
		die "wrong file format: $file";
	}
	my $exchange = $1;
	my $date     = $2;

	print "$exchange $date\n";

	# calculate date string to double check CSV files
	$date =~ /(\d\d\d\d)(\d\d)(\d\d)/;
	$date = join '-', $1, $2, $3;
	my $date_str = join '-', $3, $month[$2], $1;

	open(my $fh, '<', $file) or die $!;
	while (my $line = <$fh>) {
		chomp $line;
		next if $line eq 'Symbol,Date,Open,High,Low,Close,Volume';
		my @data = split /,/, $line;

		my $symbol = shift @data;
		if ($date_str ne shift @data) {
			die "Date mismatch: $date, $date_str and $line";
		}

		my $out_path = sprintf(
			'%s%s/%s/%s/',
			$output_path,
			$exchange,
			substr($symbol, 0, 1),
			$symbol,
		);
		make_path($out_path);

		append_file(
			$out_path . 'eod.csv',
			join(',', $date, @data) . "\n",
		);
	}
	close($fh);
}

