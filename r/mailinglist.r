## a call under Black--Scholes--Merton
callBSM <- function(S,X,tau,r,q,vol) {
   if (tau > 0) {
       d1 <- (log(S/X) + (r - q + vol^2 / 2)*tau) / (vol*sqrt(tau))
       d2 <- d1 - vol*sqrt(tau)
       S * exp(-q * tau) * pnorm(d1) - X * exp(-r * tau) * pnorm(d2)
   } else {
       pmax(S-X,0)
   }

}

## now
S <- 70:130 ## evaluate for these spot prices
X <- 100; tau <- 1; r <- 0.02; q <- 0.01; vol  <- 0.2
plot(S, callBSM(S,X,tau,r,q,vol), col = grey(.7), type="l", ylab = "payoff")

## some time later
tau <- 0.5
lines(S, callBSM(S,X,tau,r,q,vol), col = grey(.5), type="l")

## expiry
tau <- 0
lines(S, callBSM(S,X,tau,r,q,vol), col = grey(.3), type="l")

