#' Returns a table of approximate matches to a set of strings, with
#' matches selected from a specified set.
#'
#' @param seedSet A set of strings to be (approximately) matched with strings
#'  in matchSet.
#' @param matchSet A set of strings that are match candidates for the
#'  strings in seedSet.
#'
#' @return A data frame with rownames corresponding to the strings in
#'  seedSet, and each row specifying up to three top matches, as well
#'  as to the best match score.
#'
#'
#' @concept rcellminerUtils
#' @export
getStrDistTab <- function(seedSet, matchSet){
  if (!require(stringdist)){
    stop("Please install the stringdist package.")
  }
  seedSet <- unique(seedSet)
  strDistTab <- data.frame(SEED=seedSet, BEST_MATCH_SCORE=NA,
                           MATCH_1=NA, MATCH_2=NA, MATCH_3=NA,
                           stringsAsFactors=FALSE)
  rownames(strDistTab) <- strDistTab$SEED

  for (seed in rownames(strDistTab)){
    d <- stringdist(toupper(seed), toupper(matchSet), method = "jw", p=0.1)
    names(d) <- matchSet
    d <- sort(d)
    strDistTab[seed, "BEST_MATCH_SCORE"] <- d[1]
    strDistTab[seed, "MATCH_1"] <- names(d)[1]
    if (length(matchSet) > 1){
      strDistTab[seed, "MATCH_2"] <- names(d)[2]
    }
    if (length(matchSet) > 2){
      strDistTab[seed, "MATCH_3"] <- names(d)[3]
    }
  }
  strDistTab <- strDistTab[order(strDistTab$BEST_MATCH_SCORE), ]
  return(strDistTab)
}
