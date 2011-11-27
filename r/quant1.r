library(RQuantLib)

S         <- 1950:2400
cur_price <- 2150
time_left <- c(20/365, 10/365, 0/365)
vola      <- 0.3

long  <- EuropeanOptionArrays("put", S, 2100, 0, 0.01, time_left, vola)
short <- EuropeanOptionArrays("put", S, 2050, 0, 0.01, time_left, vola)


plot( S, long$value[, 3] - short$value[, 3] - short$value[, 3], col = grey(.7), type="l", ylab="payoff")
lines(S, long$value[, 2] - short$value[, 2] - short$value[, 2], col = grey(.5), type="l")
lines(S, long$value[, 1] - short$value[, 1] - short$value[, 1], col = grey(.3), type="l")
