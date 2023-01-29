#' @title Block bootstrap
#'
#' @description If data are correlated, then it is not possible to use
#'    a simple resampling due to its inability to replicate the
#'    correlation in the data. The block bootstrap tries to overcome
#'    this issue by resampling inside blocks of data.
#'
#' @usage blockboot(y, N, K = 1, L, l_gen = "poisson", indexes = TRUE,
#'      sort = FALSE, summary = FALSE, trace = TRUE)
#'
#' @param y Data to re-sample.
#' @param N Length of each simulation. If N is less or equal to the number
#'    of data, then repeated indexes cannot occur.
#' @param K Number of simulations.
#' @param L Mean length of the blocks.
#' @param l_gen Distribution of the length of the blocks. Four choices
#'    are available: \emph{poisson}, \emph{geometric}, \emph{uniform}
#'    or \emph{constant}.
#' @param indexes If it is TRUE, then \code{blockboot} returns
#'    the indexes of the re-sampled data, otherwise their values.
#' @param sort If it is TRUE, then it returns simulations
#'    whose blocks are sorted by using the first index of each block,
#'    otherwise it keeps the original order.
#' @param summary If it is TRUE, then it returns not only the
#'    simulations but also some statistics concerning each of them.
#' @param trace If it is TRUE, then the chosen configuration of
#'    the block bootstrap is printed before starting the simulations.
#'
#' @return A matrix contained the K simulations of length N or a list of 2
#'    if \code{summary} is TRUE: as first element the simulations, as second
#'    one the statistics table.
#'
#' @examples
#' data(air)
#' # default settings, N <= number of observations
#' idx <- blockboot(air$Temperature, 1250, 2, 3)
#' # user settings, N > number of observations
#' outputs <- blockboot(air$Temperature, 3010, 2, 3, "uniform",
#'                      indexes = FALSE, sort = TRUE, summary = TRUE)
#' simulations <- outputs[[1]]
#' summary <- outputs[[2]]
#'
#' @export
#'
#' @import tictoc
#' @import rlist
#' @import purrr

blockboot <- function(y, N, K = 1, L,
         l_gen = "poisson",
         indexes = TRUE,
         sort = FALSE,
         summary = FALSE,
         trace = TRUE) {

  # internal function for the case N <= n
  bb_N_small <- function(y, N, K, L, l_gen, indexes, summary, sort){
    res_star <- matrix(nrow = N, ncol = K)
    colnames(res_star) <- paste("sim", 1:K, sep = "")
    analysis <- matrix(nrow = 6, ncol = K+1)
    rownames(analysis) <- c("num. iterations", "num. blocks", "avg blocks' length",
                           "num. out-of-indexes", "num. rejected blocks",
                           "execution time (s)")
    colnames(analysis) <- c(paste("sim", 1:K, sep = ""), "avg")
    n <- length(y)
    idx <- 1:n
    max_idx <- max(idx)
    message(" ")
    for(i in 1:K){
      tic()
      cat(sprintf("Simulation %d of %d (%d%%)\n", i, K, round((i/K)*100)))
      starting_idx <- idx
      idx_star <- list()
      rej_idx <- list()
      count <- 0
      iter <- 0
      blk  <- 0
      ooi <- 0
      rej <- 0
      while(count < N){
        iter <- iter + 1
        t <- sample(unlist(starting_idx), 1)
        l <- switch(
          l_gen,
          "poisson" = rpois(1, L),
          "geometric" = rgeom(1, 1/L),
          "uniform" = rdunif(1, 1, 2*L),
          "constant" = L)
        if ((t+l-1) <= max_idx && l != 0){
          block <- t:(t+l-1)
          if (is_empty(list.search(rej_idx, any(. == block)))){
            idx_star <- append(idx_star, block)
            rej_idx <- append(rej_idx, block)
            starting_idx <- list.remove(starting_idx,
                                        match(block, unlist(starting_idx)))
            blk <- blk + 1
            count <- count + length(block)
          } else{
            rej <- rej + 1
          }
        } else{
          ooi <- ooi + 1
        }
      }
      # cutting last block
      if(length(unlist(idx_star)) > N){
        N1 <- length(unlist(idx_star))
        to_delete <- N1 - N
        idx_star <- list.remove(idx_star, (N1-to_delete+1):N1)
      }
      # sorting and unlist
      if (sort == TRUE){
        idx_star <- sort(unlist(idx_star))
      } else{
        idx_star <- unlist(idx_star)
      }
      if(indexes){
        res_star[,i] <- idx_star
      } else{
        res_star[,i] <- y[idx_star]
      }
      ex_time <- toc(quiet = TRUE)
      ex_time <- ex_time$toc - ex_time$tic
      names(ex_time) <- NULL
      analysis[,i] <- c(round(iter), blk, round(N/blk, 2), round(ooi),
                       round(rej), round(ex_time, 2))
    }
    message(" ")
    analysis[,(K+1)] <- c(round(mean(analysis[1,1:K]), 2),
                         round(mean(analysis[2,1:K]), 2),
                         round(mean(analysis[3,1:K]), 2),
                         round(mean(analysis[4,1:K]), 2),
                         round(mean(analysis[5,1:K]), 2),
                         round(mean(analysis[6,1:K]), 2))
    if(summary){
      return(list(res_star, analysis))
    } else{
      return(res_star)
    }
  }

  #internal function for the case N > n
  bb_N_big <- function(y, N, K, L, l_gen, indexes, summary, sort){
    res_star <- matrix(nrow = N, ncol = K)
    colnames(res_star) <- paste("sim", 1:K, sep = "")
    analysis <- matrix(nrow = 6, ncol = K+1)
    rownames(analysis) <- c("num. iterations", "num. blocks", "avg blocks' length",
                           "num. out-of-indexes", "num. rejected indexes",
                           "execution time (s)")
    colnames(analysis) <- c(paste("sim", 1:K, sep = ""), "avg")
    n <- length(y)
    idx <- 1:n
    max_idx <- max(idx)
    message(" ")
    for(i in 1:K){
      tic()
      cat(sprintf("Simulation %d of %d (%d%%)\n", i, K, round((i/K)*100)))
      idx_star <- list()
      rej_idx <- list()
      count <- 0
      iter <- 0
      blk  <- 0
      ooi <- 0
      rej <- 0
      while(count < N){
        iter <- iter + 1
        t <- sample(idx, 1)
        l <- switch(
          l_gen,
          "poisson" = rpois(1, L),
          "geometric" = rgeom(1, 1/L),
          "uniform" = rdunif(1, 1, 2*L),
          "constant" = L)
        if ((t+l-1) <= max_idx && l != 0){
          if(count + l > N)
            l <- N-count
          block <- t:(t+l-1)
          block_list <- list(block)
          if(length(block) > 1){
            names(block_list) <- block_list[[1]][1]
          } else{
            names(block_list) <- block_list[[1]]
          }
          if (is_empty(list.search(rej_idx, any(. == block[1])))){
            idx_star <- append(idx_star, block_list)
            rej_idx <- append(rej_idx, block[1])
            blk <- blk + 1
            count <- count + length(block)
          } else{
            rej <- rej + 1
          }
        } else{
          ooi <- ooi + 1
        }
      }
      # sorting and unlist
      if (sort == TRUE){
        sorting <- sort(as.numeric(names(idx_star)))
        idx_star <- unlist(idx_star[as.character(sorting)])
      } else{
        idx_star <- unlist(idx_star)
      }
      names(idx_star) <- NULL
      if(indexes){
        res_star[,i] <- idx_star
      } else{
        res_star[,i] <- y[idx_star]
      }
      ex_time <- toc(quiet = TRUE)
      ex_time <- ex_time$toc - ex_time$tic
      names(ex_time) <- NULL
      analysis[,i] <- c(round(iter), blk, round(N/blk, 2), round(ooi),
                       round(rej), round(ex_time, 2))
    }
    message(" ")
    analysis[,(K+1)] <- c(round(mean(analysis[1,1:K]), 2),
                         round(mean(analysis[2,1:K]), 2),
                         round(mean(analysis[3,1:K]), 2),
                         round(mean(analysis[4,1:K]), 2),
                         round(mean(analysis[5,1:K]), 2),
                         round(mean(analysis[6,1:K]), 2))
    if(summary){
      return(list(res_star, analysis))
    } else{
      return(res_star)
    }
  }

  if(trace){
    cat("\n")
    cat("Block bootstrap configuration:\n")
    cat(sprintf("- simulation length (N): %d\n", N))
    cat(sprintf("- simulations number (K): %d\n", K))
    cat(sprintf("- mean blocks length (L): %d\n", L))
    cat(sprintf("- blocks length distribution: %s\n", l_gen))
    cat(sprintf("- indixes: %s\n", indexes))
    cat(sprintf("- summary: %s\n", summary))
    cat(sprintf("- sort: %s\n", sort))
    if(N <= length(y)){
      cat("- N <= n -> no ripetions\n")
    } else {
      cat("- N > n -> yes ripetions\n")
    }
  }

  if(N <= length(y)){
    return(bb_N_small(y, N, K, L, l_gen, indexes, summary, sort))
  } else {
    return(bb_N_big(y, N, K, L, l_gen, indexes, summary, sort))
  }
}
