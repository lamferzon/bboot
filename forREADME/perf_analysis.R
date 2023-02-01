
library(devtools)
# install_github("lamferzon/block-bootstrap-for-R")
library(bboot)
library(latex2exp)
library(hexSticker)
library(showtext)
rm(list = ls())

# Simulations --------------------------------------------------------------
N_set <- seq(2, 4382, 10)
n <- length(N_set)
res_table <- data.frame(N = N_set,
                        time_pois = rep(0, n),
                        length_pois = rep(0, n),
                        rej_pois = rep(0, n),
                        time_pois_rej = rep(0, n),
                        length_pois_rej = rep(0, n),
                        rej_pois_rej = rep(0, n))
j <- 1
for (i in N_set){
  cat(i)
  outs <- blockboot(air$Temperature, i, 5, 3, "poisson",
                    indexes = TRUE, reject = FALSE, sort = FALSE,
                    summary = TRUE, trace = FALSE)
  outs <- outs[[2]]
  res_table$length_pois[j] <- outs[3,6]
  res_table$rej_pois[j] <- outs[5,6]
  res_table$time_pois[j] <- outs[6,6]
  j <- j + 1
}

j <- 1
for (i in N_set){
  cat(i)
  outs <- blockboot(air$Temperature, i, 5, 3, "poisson",
                    indexes = TRUE, reject = TRUE, sort = FALSE,
                    summary = TRUE, trace = FALSE)
  outs <- outs[[2]]
  res_table$length_pois_rej[j] <- outs[3,6]
  res_table$rej_pois_rej[j] <- outs[5,6]
  res_table$time_pois_rej[j] <- outs[6,6]
  j <- j + 1
}

save(res_table, file = "C:/Users/loren/Desktop/bboot/forREADME/res_table.RData")

# Results -----------------------------------------------------------------
load("forREADME/res_table.RData")

perc <- (res_table$N/length(air$Temperature))

# no rejection
par(mgp=c(2,0.5,0), mar=c(4,4,2,4)+0.1)
plot(perc, res_table$time_pois,
     col = "darkorange",
     xlab = TeX("Ratio N/n"),
     ylab = "",
     ylim = c(0,110),
     lwd = 1.5)
mtext(TeX("Execution time [s]"),
      side = 2,
      line = 2,
      col = "darkorange")
grid(ny = NA, nx = NULL)
par(new=TRUE)
plot(perc, res_table$length_pois,
     col = "green2",
     axes = FALSE,
     xlab = "",
     ylab = "",
     ylim = c(2, 4),
     lwd = 1.5)
abline(h = 3,
       lwd = 1.5,
       col = "red")
text(0, 3.05, TeX("L chosen"),
     srt = 0,
     cex = 1)
axis(4, ylim=c(0,max(res_table$length_pois)), las = 1)
mtext(TeX("Mean blocks length"),
      side = 4,
      line = 2,
      col = "green2")

# yes rejection
par(mgp=c(2,0.5,0), mar=c(4,4,2,4)+0.1)
plot(perc, res_table$time_pois_rej,
     col = "darkorange",
     xlab = TeX("Ratio N/n"),
     ylab = "",
     ylim = c(0,110),
     lwd = 1.5)
mtext(TeX("Execution time [s]"),
      side = 2,
      line = 2,
      col = "darkorange")
grid(ny = NA, nx = NULL)
par(new=TRUE)
plot(perc, res_table$length_pois_rej,
     col = "green2",
     axes = FALSE,
     xlab = "",
     ylab = "",
     ylim = c(2, 4),
     lwd = 1.5)
abline(h = 3,
       lwd = 1.5,
       col = "red")
text(0, 3.05, TeX("L chosen"),
     srt = 0,
     cex = 1)
axis(4, ylim=c(0,max(res_table$length_pois)), las = 1)
mtext(TeX("Mean blocks length"),
      side = 4,
      line = 2,
      col = "green2")

# Hexagon sticker ---------------------------------------------------------
imgurl <- "forREADME/leo.png"
font_add_google("Gochi Hand", "gochi")
icon <- sticker(imgurl,
                package = "bboot",
                p_size = 26,
                p_y = 1.53,
                s_x = 1,
                s_y = .82,
                s_width =.55,
                filename ="forREADME/logo.png",
                h_fill = "beige",
                h_color = "chocolate3",
                p_color = "darkorange",
                url = "https://github.com/lamferzon/block-bootstrap-for-R",
                u_size = 3,
                p_family = "gochi",
                white_around_sticker = TRUE)

