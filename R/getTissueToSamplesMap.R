#' Get a named list mapping from tissue types to associated samples.
#'
#'
#' @concept rcellminerUtilsCDB
#' @export
getTissueToSamplesMap <- function(sampleData, typeLevelSeparator = ":"){
  stopifnot(all(!duplicated(sampleData$Name)))
  rownames(sampleData) <- sampleData$Name
  tissueToSamples <- list()
  ocLevels <- paste0("OncoTree", 1:4)

  for (sample in rownames(sampleData)){
    sampleOcTypes <- as.character(sampleData[sample, ocLevels])
    typeName <- sampleOcTypes[1]
    if (is.na(typeName)){
      next
    }

    tissueToSamples[[typeName]] <- c(tissueToSamples[[typeName]], sample)
    for (i in (2:4)){
      if (is.na(sampleOcTypes[i])){
        break
      }
      typeName <- paste0(typeName, typeLevelSeparator, sampleOcTypes[i])
      tissueToSamples[[typeName]] <- c(tissueToSamples[[typeName]], sample)
    }
  }

  return(tissueToSamples)
}
