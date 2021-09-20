#' Get principal component analysis results for a data matrix.
#'
#' @param X A data matrix with observations along the rows and
#'   variables along the columns.
#' @param center A logical value indicating whether the variables
#'   should be shifted to be zero centered.
#' @param scale A logical value indicating whether the variables
#'   should be scaled to have unit variance
#'
#' @return A list with the following elements:
#' $dat A data matrix with respect to the new principal component
#'   variables, i.e., the projections of the observed data onto
#'   the eigenvectors of the estimated covariance matrix.
#' $evecs A matrix with with variable loadings, i.e., the
#'   eigenvectors of the estimated covariance matrix along the
#'   columns.
#' $sdev The standard deviations of the principal components, i.e.,
#'   the square roots of the eigenvalues of the estimated
#'   covariance matrix.
#' $pctVar A vector indicating the percent variance associated
#'   with each principal component.
#' $cumPctVar A vector indicating the cumulative percent variance
#'   associated with each added principal component.
#'
#' @examples
#' X <- matrix(runif(100), nrow = 25)
#' rownames(X) <- paste0("obs_", seq_len(nrow(X)))
#' colnames(X) <- paste0("var_", seq_len(ncol(X)))
#' pcaResults <- getPcaResults(X)
#'
#' @concept rcellminerUtils
#' @export
#' @importFrom stats prcomp
getPcaResults <- function(X, center = TRUE, scale = TRUE){
  prcompOut <- prcomp(x = X, center = center, scale = scale)

  pcaResults <- list()
  pcaResults$dat   <- prcompOut$x
  pcaResults$evecs <- prcompOut$rotation

  pcaResults$sdev <- prcompOut$sdev
  pcVar <- pcaResults$sdev^2
  pcaResults$pctVar    <- pcVar/sum(pcVar)
  pcaResults$cumPctVar <- cumsum(pcaResults$pctVar)

  return(pcaResults)
}
