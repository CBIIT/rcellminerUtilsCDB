#' Get a table of matched cell lines across data sources.
#'
#' @param dataSources A character vector of (two or more) data sources chosen
#' from "nci60", "ccle", "cgp", "gdsc", "gdscDec15", "ctrp", "nciSclc".
#'
#' @return A data frame with matched cell lines, one column per source.
#'
#' @examples
#' getMatchedCellLines(c("ccle", "cgp", "nci60"))
#'
#' @concept rcellminerUtils
#' @export
getMatchedCellLines <- function(dataSources){
  if (!(length(dataSources) > 1)){
    stop("Please submit 2 or more data sources.")
  }
  if (!all(dataSources %in% colnames(cellLineMatchTab))){
    stop("Submitted data sources not currently supported.")
  }

  isMatched <- rep(TRUE, nrow(cellLineMatchTab))
  for (datSource in dataSources){
    isMatched <- isMatched & (!(is.na(cellLineMatchTab[, datSource])))
  }

  matchedTab <- cellLineMatchTab[isMatched, dataSources]
  if (any(isMatched)){
    rownames(matchedTab) <- as.character(seq(nrow(matchedTab)))
  }

  # Note: we do not want to sort the results with respect to a particular
  # column, because we want to ensure that the table is the same for the
  # same input data sources, irrespective of how they are ordered.

  return(matchedTab)
}
