# Block bootstrap for R <img src='forREADME/logo.png' align="right" height="145" />

[![codecov](https://codecov.io/gh/lamferzon/block-bootstrap-for-R/branch/main/graph/badge.svg?token=BS7OQ5ELIN)](https://codecov.io/gh/lamferzon/block-bootstrap-for-R)

## Author ##
**Lorenzo LEONI**, postgraduate in Computer Engineering at University of Bergamo.

## Description ##
If data are correlated, then it is not possible to use a simple resampling due to its inability to replicate the correlation in the data. The block bootstrap tries to overcome this issue by resampling inside blocks of data.

## Installation ##
Install the bboot package via GitHub:
``` r
# install.packages("devtools")
devtools::install_github("lamferzon/block-bootstrap-for-R")
library(bboot)
``` 
## Performance analysis ##
The configuration chosen for testing the function ```blockboot()``` is:
``` r
n <- length(air$Temperature) # 2192
N <- seq(2, 4382, 10)
K <- 5
L <- 3
l_gen <- "poisson"
```
The following graphs describe the trend of the mean computational time and of the mean blocks length as a function of the N/n ratio:
![Image 1](ForREADME/trend.png)
![Image 2](ForREADME/trend_rej.png)
