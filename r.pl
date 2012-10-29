#!perl -w

use strict;
use warnings;

use Statistics::R;

my $R = Statistics::R->new;

$R->run('pdf("file.pdf")');
$R->run(<<'EOF');

library(RQuantLib)

S         <- 1950:2400
cur_price <- 2150
time_left <- c(20/365, 10/365, 1/365)
vola      <- 0.3

long  <- EuropeanOptionArrays("put", S, 2100, 0, 0.01, time_left, vola)
short <- EuropeanOptionArrays("put", S, 2050, 0, 0.01, time_left, vola)

expiration <- function(S, X) {
    pmax(X-S, 0)
}    


plot( S, long$value[, 3] - 2 * short$value[, 3], col = grey(.7), type="l", ylab="payoff", ylim=c(-10, 50))
lines(S, long$value[, 2] - 2 * short$value[, 2], col = grey(.5), type="l")
lines(S, long$value[, 1] - 2 * short$value[, 1], col = grey(.3), type="l")
lines(S, expiration(S, 2100) - 2 * expiration(S, 2050), col = "red", type = "l")

EOF

$R->stop;

