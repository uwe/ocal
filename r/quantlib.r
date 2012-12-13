library(RQuantLib)

und.seq <- seq(10, 180, by = 5)
vol.seq <- seq(0.2, 0.8, by = 0.1)

EOarr <- EuropeanOptionArrays("call", underlying = und.seq, strike = 100, dividendYield = 0.01, riskFreeRate = 0.03, maturity = 1, volatility = vol.seq)

#old.par <- par(no.readonly = TRUE)

#par(mfrow = c(2, 2), oma = c(5, 0, 0, 0), mar = c(2, 2, 2, 1))

plot(EOarr$parameter$underlying, EOarr$value[, 1], type = "n", main = "option value", xlab = "", ylab = "")

#for (i in 1:length(vol.seq)) lines(EOarr$parameter$underlying, EOarr$value[, i], col = i)
#  plot(EOarr$parameter$underlying, EOarr$delta[, 1], type = "n", main = "option delta", xlab = "", ylab = "")

#for (i in 1:length(vol.seq)) lines(EOarr$parameter$underlying, EOarr$delta[, i], col = i)
#  plot(EOarr$parameter$underlying, EOarr$gamma[, 1], type = "n", main = "option gamma", xlab = "", ylab = "")

#for (i in 1:length(vol.seq)) lines(EOarr$parameter$underlying, EOarr$gamma[, i], col = i)
#  plot(EOarr$parameter$underlying, EOarr$vega[, 1], type = "n", main = "option vega", xlab = "", ylab = "")

#for (i in 1:length(vol.seq)) lines(EOarr$parameter$underlying, EOarr$vega[, i], col = i)
#  mtext(text = paste("Strike is 100, maturity 1 year, riskless rate 0.03", "\nUnderlying price from", und.seq[1], "to", und.seq[length(und.seq)], "\nVolatility  from", vol.seq[1], "to", vol.seq[length(vol.seq)]), side = 1, font = 1, outer = FALSE)

#par(old.par)
