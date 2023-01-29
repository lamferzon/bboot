#' Extract from AgrImOnIA dataset
#'
#' The source dataset contains data concerning the concentrations of air
#' pollutants, main weather and geographical variables and soil usage. Data
#' are daily and concern Lombardia (Italy) in the period 2016-2020.
#' This dataset is an extract from the original one; it contains temperature
#' and PM 2.5 sampled by a Sondrio station.
#'
#' @docType data
#'
#' @usage data(air)
#'
#' @format An object of class \emph{data frame}.
#'
#' @keywords dataset
#'
#' @source \href{https://zenodo.org/record/6620530#.Y1ZsD-xBz1I}{Agriculture Impact On Italian Air (AgrImOnIA) dataset}
#'
#' @examples
#' data(air)
#' par(mgp = c(2,0.5,0), mar = c(4,4,1.5,4)+0.1)
#' plot(air$Datetime, air$PM25,
#'      type = "l",
#'      col = "deepskyblue1",
#'      xlab = "Time [day]",
#'      ylab = "",
#'      las = 1)
#' mtext("PM 2.5 [ug/m^3]",
#'       side = 2,
#'       line = 2,
#'       col = "deepskyblue1")
#' grid(ny = NULL, nx = NA)
#' par(new=TRUE)
#' plot(air$Datetime, air$Temperature,
#'      type = "l",
#'      col = "chocolate1",
#'      axes = FALSE,
#'      xlab = "",
#'      ylab = "")
#' axis(4, ylim=c(0,max(air$Temperature)), las = 1)
#' mtext("Temperature [°C]",
#'       side = 4,
#'       line = 2,
#'       col = "chocolate1")
#'
"air"
