package OCal::Quotes;

use Moo;

use File::Slurp qw/read_file/;
use List::MoreUtils qw/first_index/;


has quotes_path => (is => 'ro', default => sub { 'C:/quotes' });
has exchange    => (is => 'ro', default => sub { 'NASDAQ' });
has symbol      => (is => 'ro', required => 1);


sub get_all {
	my ($self) = @_;

	my @lines = read_file($self->data_file, {chomp => 1});

	# put into hash to avoid duplicates (and sort afterwards)
	my %data  = ();
	foreach my $line (@lines) {
		my ($date, $open, $high, $low, $close, $volume) = split /,/, $line;
		$data{$date} = {
			date   => $date,
			open   => $open,
			high   => $high,
			low    => $low,
			close  => $close,
			volume => $volume,
		};
	}
	my @data = sort { $a->{date} cmp $b->{date} } values %data;

	return \@data;
}

sub get_specific {
	my ($self, %arg) = @_;

	my $quotes = $self->get_all;

	my $end_date  = $arg{end_date}  || $quotes->[-1]->{date};
	my $bar_count = $arg{bar_count} || 0;

	# search for end date
	my $index = first_index { $_->{date} eq $end_date } @$quotes;
	die "End date $end_date not found" if $index == -1;

	$bar_count ||= $index + 1;
	if ($bar_count > $index + 1) {
		die "Not enough bars ($bar_count) for end date ($end_date)";
	}

	my @data = splice(@$quotes, $index - $bar_count + 1, $bar_count);
	return \@data;
}

sub hv {
	my ($self, $end_date, $n) = @_;

	die "End date missing" unless $end_date;

	$n ||= 252;

	die;
}

sub data_file {
	my ($self) = @_;

	return join(
		'/',
		$self->quotes,
		$self->exchange,
		substr($self->symbol, 0, 1),
		$self->symbol,
		'eod.csv',
	);
}

1;

