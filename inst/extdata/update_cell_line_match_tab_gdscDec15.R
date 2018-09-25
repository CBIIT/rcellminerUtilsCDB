#--------------------------------------------------------------------------------------------------
# LOAD INPUT DATA AND CONSTRUCT STARTING CELL LINE MATCH TABLE.
#--------------------------------------------------------------------------------------------------
library(rcellminerUtils)
library(dplyr)
library(stringr)

newCellMatchTab <- rcellminerUtils::cellLineMatchTab
newCellMatchTab$gdscDec15 <- NA
newCellMatchTab <- newCellMatchTab[, c("nci60", "ccle", "cgp", "gdsc", "gdscDec15")]

nci60Lines <- colnames(getAllFeatureData(rcellminerData::molData)[["exp"]])
ccleLines  <- colnames(getAllFeatureData(ccleData::molData)[["exp"]])
cgpLines   <- colnames(getAllFeatureData(cgpData::molData)[["exp"]])
gdscLines  <- colnames(getAllFeatureData(gdscData::molData)[["exp"]])
gdscDec15Lines <- colnames(getAllFeatureData(gdscDataDec15::molData)[["exp"]])

for (i in (1:nrow(newCellMatchTab))){
  gdscCellLine <- newCellMatchTab[i, "gdsc"]
  if (!is.na(gdscCellLine)){
    if (gdscCellLine %in% gdscDec15Lines){
      newCellMatchTab[i, "gdscDec15"] <- gdscCellLine
    }
  }
}

addedGdscDec15Lines <- setdiff(gdscDec15Lines, gdscLines)

#--------------------------------------------------------------------------------------------------
# CHECK FOR FUZZY MATCHES OF GDSC LINES WITH GDSCDEC15 LINES.
#--------------------------------------------------------------------------------------------------

# strDistTab_gdsc_gdscDec15Added <- getStrDistTab(seedSet = gdscLines,
#                                                 matchSet = addedGdscDec15Lines)
#
# write.table(strDistTab_gdsc_gdscDec15Added,
#             file="inst/extdata/gdsc_gdscDec15Added_match.txt", quote=FALSE,
#             sep="\t", row.names=FALSE, col.names=TRUE, na="NA")

# Table of directly checked and filtered (valid) matches.
strDistTab_gdsc_gdscDec15Added <- read.table(file="inst/extdata/gdsc_gdscDec15Added_match_filtered.txt",
                                             header=TRUE, sep="\t", stringsAsFactors=FALSE,
                                             comment.char="", quote="")
rownames(strDistTab_gdsc_gdscDec15Added) <- strDistTab_gdsc_gdscDec15Added$SEED

for (cLine in strDistTab_gdsc_gdscDec15Added$SEED){
  i <- which(newCellMatchTab$gdsc == cLine)
  stopifnot(length(i) == 1)
  newCellMatchTab[i, "gdscDec15"] <- strDistTab_gdsc_gdscDec15Added[cLine, "MATCH_1"]
}

addedGdscDec15Lines <- setdiff(addedGdscDec15Lines, strDistTab_gdsc_gdscDec15Added$MATCH_1)

#--------------------------------------------------------------------------------------------------
# CHECK FOR FUZZY MATCHES OF CCLE LINES WITH GDSCDEC15 LINES.
#--------------------------------------------------------------------------------------------------

# strDistTab_ccle_gdscDec15Added <- getStrDistTab(seedSet = ccleLines,
#                                                 matchSet = addedGdscDec15Lines)
#
# write.table(strDistTab_ccle_gdscDec15Added,
#             file="inst/extdata/ccle_gdscDec15Added_match.txt", quote=FALSE,
#             sep="\t", row.names=FALSE, col.names=TRUE, na="NA")

# Table of directly checked and filtered (valid) matches.
strDistTab_ccle_gdscDec15Added <- read.table(file="inst/extdata/ccle_gdscDec15Added_match_filtered.txt",
                                             header=TRUE, sep="\t", stringsAsFactors=FALSE,
                                             comment.char="", quote="")
rownames(strDistTab_ccle_gdscDec15Added) <- strDistTab_ccle_gdscDec15Added$SEED

for (cLine in strDistTab_ccle_gdscDec15Added$SEED){
  i <- which(newCellMatchTab$ccle == cLine)
  stopifnot(length(i) == 1)
  newCellMatchTab[i, "gdscDec15"] <- strDistTab_ccle_gdscDec15Added[cLine, "MATCH_1"]
}

addedGdscDec15Lines <- setdiff(addedGdscDec15Lines, strDistTab_ccle_gdscDec15Added$MATCH_1)

#--------------------------------------------------------------------------------------------------
# CHECK FOR FUZZY MATCHES OF CGP LINES WITH GDSCDEC15 LINES.
#--------------------------------------------------------------------------------------------------

strDistTab_cgp_gdscDec15Added <- getStrDistTab(seedSet = cgpLines,
                                              matchSet = addedGdscDec15Lines)

strDistTab_cgp_gdscDec15Added <- filter(strDistTab_cgp_gdscDec15Added, BEST_MATCH_SCORE == 0)
rownames(strDistTab_cgp_gdscDec15Added) <- strDistTab_cgp_gdscDec15Added$SEED

for (cLine in strDistTab_cgp_gdscDec15Added$SEED){
  i <- which(newCellMatchTab$cgp == cLine)
  stopifnot(length(i) == 1)
  newCellMatchTab[i, "gdscDec15"] <- strDistTab_cgp_gdscDec15Added[cLine, "MATCH_1"]
}

addedGdscDec15Lines <- setdiff(addedGdscDec15Lines, strDistTab_cgp_gdscDec15Added$MATCH_1)

#--------------------------------------------------------------------------------------------------
# CHECK FOR FUZZY MATCHES OF NCI-60 LINES WITH GDSCDEC15 LINES.
#--------------------------------------------------------------------------------------------------

# nci60LinesTrimmed <- vapply(nci60Lines, FUN = function(x) { str_split(x, ":")[[1]][2] },
#                                    FUN.VALUE = character(1))
# strDistTab_nci60_gdscDec15Added <- getStrDistTab(seedSet = nci60LinesTrimmed,
#                                                  matchSet = addedGdscDec15Lines)

# Note: no matches found.

#--------------------------------------------------------------------------------------------------
# ADD ROWS CORRESPONDING TO REMAINING UNMATCHED, ADDED GDSCDEC15 LINES.
#--------------------------------------------------------------------------------------------------

tmp <- data.frame(nci60 = NA, ccle = NA, cgp = NA, gdsc = NA, gdscDec15 = addedGdscDec15Lines,
                  stringsAsFactors = FALSE)
stopifnot(identical(colnames(tmp), colnames(newCellMatchTab)))

newCellMatchTab <- rbind(newCellMatchTab, tmp)

# checks --------------------------------------------------------------------------------
stopifnot(identical(sort(nci60Lines), sort(na.exclude(newCellMatchTab$nci60))))
stopifnot(identical(sort(ccleLines), sort(na.exclude(newCellMatchTab$ccle))))
stopifnot(identical(sort(cgpLines), sort(na.exclude(newCellMatchTab$cgp))))
stopifnot(identical(sort(gdscLines), sort(na.exclude(newCellMatchTab$gdsc))))
stopifnot(identical(sort(gdscDec15Lines), sort(na.exclude(newCellMatchTab$gdscDec15))))
# ---------------------------------------------------------------------------------------

cellLineMatchTab <- newCellMatchTab
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
