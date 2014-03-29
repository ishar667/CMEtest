
##########
## TODO ##
##########
## (Ishmael): Consider adding the 1 - Q point mass at zero for Q < 1 to the mp desnity
## (Ishmael): Consider asymptotic approximation for very large k in the mp mom function

######################
## Marchenko-Pastur ##
######################


#,----
#| Marchenko-Pastur density
#`----


dmarpasV2 <- function(x, sigma, Q) {
    x <- as.array(x)
    if(sigma < 0)
        stop("sigma should be positive")
    if(Q < 0)
        stop("Q should be positive")

    lambdaPlus <- sigma^2 * (1 + sqrt(1/Q))^2
    lambdaMinus <- sigma^2 * (1 - sqrt(1/Q))^2
    constant <- Q/(2 * pi * sigma^2)

    supportCond <- (lambdaMinus < x) && (x < lambdaPlus)
    density <- array(0, dim(x))


    density[supportCond] <- constant *
        sqrt((lambdaPlus - x[supportCond]) *
             (x[supportCond] - lambdaMinus)) / x[supportCond]

    cat(density[supportCond])
    return(density)
}

dmarpasV1 <- function(x, sigma, Q) {
    ##x <- as.array(x)
    if(sigma < 0)
        stop("sigma should be positive")
    if(Q < 0)
        stop("Q should be positive")

    lambdaPlus <- sigma^2 * (1 + sqrt(1/Q))^2
    lambdaMinus <- sigma^2 * (1 - sqrt(1/Q))^2

    supportCond <- (lambdaMinus < x) && (x < lambdaPlus)

    if(supportCond) {
    constant <- Q/(2 * pi * sigma^2)
    density <- constant * sqrt((lambdaPlus - x) * (x - lambdaMinus)) / x
    } else {

    density <- 0
    }

    return(density)
}

#,----
#| Marchenko-Pastur distribution
#`----

dmarpas <- function(x, sigma, Q) {

    density <- Vectorize(function(X) dmarpasV1(X, sigma, Q))

    return(density(x))
}

pmarpas <- function(p, sigma, Q) {

    if(is.infinite(p) && (sign(p) == -1)) {
        cdf <- 0
    } else {
        integrand <- function(x) dmarpas(x, sigma, Q)
        integral <- integrate(integrand, lower = -Inf, upper = p)
        cdf <- integral$value
    }

    return(cdf)
}


#,----
#| Marchenko-Pastur Moments
#`----

marpasMom <- function(k, sigma, Q, return.all = FALSE) {
    if(sigma < 0)
        stop("sigma should be positive")
    if(Q < 0)
        stop("Q should be positive")
    if(k < 0)
        stop("k should be positive")

    krange <- 0:(k - 1)
    momentsVec <- 1/(krange + 1) *
        choose(k, krange) * choose(k - 1, krange) * (1/Q)^(krange)

    if(return.all) {
        moments <- sigma^(2 * (1:k)) * cumsum(momentsVec)
    } else {
        moments <- sigma^(2 * k) * sum(momentsVec)
    }

    return(moments)

}

