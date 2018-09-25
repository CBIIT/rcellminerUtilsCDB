#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE AND SAVE
#--------------------------------------------------------------------------------------------------
library(rcellminerUtils)
# library(nciSclcData)
#
# sclcLineAnnot <- rcellminer::getSampleData(nciSclcData::drugData)
# rownames(sclcLineAnnot) <- sclcLineAnnot$Name

newCellMatchTab <- rcellminerUtils::cellLineMatchTab
newCellMatchTab$almanac <- newCellMatchTab$nci60

# findMatchIndex <- function(cLine){
#   dataSources <- c("nci60", "ccle", "cgp", "gdsc", "gdscDec15", "ctrp")
#   i <- NA
#   for (dataSrc in dataSources){
#     iTmp <- which(newCellMatchTab[, dataSrc] == cLine)
#     if (length(iTmp) == 1){
#       i <- iTmp
#       break
#     }
#   }
#   return(i)
# }

# matchedSclcLines <- NULL
# for (cLine in rownames(sclcLineAnnot)){
#   i <- findMatchIndex(cLine)
#   if (!is.na(i)){
#     newCellMatchTab[i, "nciSclc"] <- cLine
#     matchedSclcLines <- c(matchedSclcLines, cLine)
#   }
# }

# unmatchedSclcTab <- data.frame(
#   nci60 = NA,
#   ccle = NA,
#   cgp = NA,
#   gdsc = NA,
#   gdscDec15 = NA,
#   ctrp = NA,
#   nciSclc = setdiff(rownames(sclcLineAnnot), matchedSclcLines),
#   stringsAsFactors = FALSE
# )
# stopifnot(identical(colnames(newCellMatchTab), colnames(unmatchedSclcTab)))
# newCellMatchTab <- rbind(newCellMatchTab, unmatchedSclcTab)
#
# stopifnot(identical(
#   sort(na.exclude(newCellMatchTab$nciSclc)),
#   sort(sclcLineAnnot$Name)
# ))

cellLineMatchTab <- newCellMatchTab
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
