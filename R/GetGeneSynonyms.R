#' Get Gene Synonyms
#'
#' @param gene A gene symbol.
#'
#' @return A vector of list of synonyms including the input data
#' 
#' @examples
#' Results <- getGeneSynonyms("CGAS")
#'
#'
#' @concept rcellminerUtilsCDB
#' @export
getGeneSynonyms <- function(gene){

  Synonym <- rcellminerUtilsCDB::HugoGeneSynonyms$all_synonyms
  hugonames <- rcellminerUtilsCDB::HugoGeneSynonyms$Approved.symbol
  
  gene <- toupper(trimws(gene))
  # i <- which(vapply(Synonym, function(x){ gene %in% toupper(x) }, logical(1)))
  i <- which(vapply(hugonames, function(x){ gene %in% toupper(x) }, logical(1)))
  
  if (length(i) == 1){
    Syn <- Synonym[[i]]
     } 
   else{
      j <- which(vapply(Synonym, function(x){ gene %in% toupper(x) }, logical(1)))
      if (length(j) == 1){
         Syn <- Synonym[[j]] 
       }
       else {
         Syn <- NULL
      }
  }
  
  return(Syn)
}
#--------------------------------------------------------------------------------------------------
