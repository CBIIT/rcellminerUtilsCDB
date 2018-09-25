#' Get a character vector with data source-specific identifiers for
#' the named drug, if available.
#'
#' @param drugName A drug name.
#' @param dbName A data source chosen from "nci60", "ccle", "gdscDec15",
#' "ctrp", "nciSclc".
#'
#' @return A character vector with data source-specific identifiers for
#' the named drug, if available; otherwise returns NULL
#'
#' @examples
#' getDbDrugIds(drugName = "Topotecan", dbName = "nci60")
#'
#' @concept rcellminerUtils
#' @export
getDbDrugIds <- function(drugName, dbName){
  availableDbs <- colnames(rcellminerUtils::drugSynonymTab[,-1])
  if (!(dbName %in% availableDbs)){
    stop(paste0("Select dbName from: ", paste0(availableDbs, collapse = ", "), "."))
  }

  availableInDb <- !is.na(rcellminerUtils::drugSynonymTab[, dbName])
  dbDrugSynTab <- rcellminerUtils::drugSynonymTab[availableInDb, ]

  drugName <- toupper(drugName)
  i <- which(vapply(dbDrugSynTab$NAME_SET, function(x){ drugName %in% x }, logical(1)))

  if (length(i) == 1){
    dbDrugIds <- dbDrugSynTab[[i, dbName]]
  } else{
    dbDrugIds <- NULL
  }

  return(dbDrugIds)
}

