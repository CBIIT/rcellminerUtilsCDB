#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
library(rcellminerUtils)
library(cgpData)
library(gdscData)
library(stringr)
library(stringdist)

newCellMatchTab <- cellLineMatchTab
newCellMatchTab$gdsc <- NA
newCellMatchTab <- newCellMatchTab[, c("nci60", "cgp", "gdsc", "ccle")]

cgpExp <- getAllFeatureData(cgpData::molData)[["exp"]]
gdscExp <- getAllFeatureData(gdscData::molData)[["exp"]]
ccleExp <- getAllFeatureData(ccleData::molData)[["exp"]]
nci60Exp <- getAllFeatureData(rcellminerData::molData)[["exp"]]

sharedLines <- intersect(colnames(cgpExp), colnames(gdscExp))
cgpOnlyLines <- setdiff(colnames(cgpExp), colnames(gdscExp))
gdscOnlyLines <- setdiff(colnames(gdscExp), colnames(cgpExp))

#--------------------------------------------------------------------------------------------------
# ADD ENTRIES FOR SHARED (CGP, GDSC) LINES
#--------------------------------------------------------------------------------------------------

for (i in (1:nrow(newCellMatchTab))){
  if (newCellMatchTab[i, "cgp"] %in% sharedLines){
    newCellMatchTab[i, "gdsc"] <- newCellMatchTab[i, "cgp"]
  }
}

#--------------------------------------------------------------------------------------------------
# LOOK FOR FUZZY MATCHES: CGP TO GDSC-ONLY.
#--------------------------------------------------------------------------------------------------

strDistTab <- getStrDistTab(seedSet = cgpOnlyLines, matchSet = gdscOnlyLines)
write.table(strDistTab, file="inst/extdata/cgpOnly_gdscOnly_match.txt", quote=FALSE,
            sep="\t", row.names=FALSE, col.names=TRUE, na="NA")

strDistTab <- read.table(file="inst/extdata/cgpOnly_gdscOnly_match_filtered.txt",
                         header=TRUE, sep="\t", stringsAsFactors=FALSE, comment.char="", quote="")
rownames(strDistTab) <- strDistTab$SEED

for (cLine in strDistTab$SEED){
  i <- which(newCellMatchTab$cgp == cLine)
  stopifnot(length(i) == 1)
  newCellMatchTab[i, "gdsc"] <- strDistTab[cLine, "MATCH_1"]
}

gdscOnlyLines <- setdiff(gdscOnlyLines, strDistTab$MATCH_1)
#--------------------------------------------------------------------------------------------------
# LOOK FOR FUZZY MATCHES: NCI-60 TO GDSC-ONLY.
#--------------------------------------------------------------------------------------------------

isUnmatchedNci60 <- (!is.na(newCellMatchTab$nci60)) & (is.na(newCellMatchTab$gdsc))
unMatchedNci60 <- newCellMatchTab$nci60[isUnmatchedNci60]

unMatchedNci60 <- unname(vapply(unMatchedNci60, function(x) {
  str_split(x, ":")[[1]][[2]]
}, character(1)))

strDistTab <- getStrDistTab(seedSet = unMatchedNci60, matchSet = gdscOnlyLines)
write.table(strDistTab, file="inst/extdata/nci60_gdscOnly_match.txt", quote=FALSE,
            sep="\t", row.names=FALSE, col.names=TRUE, na="NA")

strDistTab <- read.table(file="inst/extdata/nci60_gdscOnly_match_filtered.txt",
                         header=TRUE, sep="\t", stringsAsFactors=FALSE, comment.char="", quote="")
rownames(strDistTab) <- strDistTab$SEED

for (cLine in strDistTab$SEED){
  i <- which(newCellMatchTab$nci60 == cLine)
  stopifnot(length(i) == 1)
  newCellMatchTab[i, "gdsc"] <- strDistTab[cLine, "MATCH_1"]
}

gdscOnlyLines <- setdiff(gdscOnlyLines, strDistTab$MATCH_1)

#--------------------------------------------------------------------------------------------------
# LOOK FOR FUZZY MATCHES: CCLE TO GDSC-ONLY.
#--------------------------------------------------------------------------------------------------

isUnmatchedCcle <- (!is.na(newCellMatchTab$ccle)) & (is.na(newCellMatchTab$gdsc))
unMatchedCcle <- newCellMatchTab$ccle[isUnmatchedCcle]

strDistTab <- getStrDistTab(seedSet = unMatchedCcle, matchSet = gdscOnlyLines)
write.table(strDistTab, file="inst/extdata/ccle_gdscOnly_match.txt", quote=FALSE,
            sep="\t", row.names=FALSE, col.names=TRUE, na="NA")

strDistTab <- read.table(file="inst/extdata/ccle_gdscOnly_match_filtered.txt",
                         header=TRUE, sep="\t", stringsAsFactors=FALSE, comment.char="", quote="")
rownames(strDistTab) <- strDistTab$SEED

for (cLine in strDistTab$SEED){
  i <- which(newCellMatchTab$ccle == cLine)
  stopifnot(length(i) == 1)
  newCellMatchTab[i, "gdsc"] <- strDistTab[cLine, "MATCH_1"]
}

gdscOnlyLines <- setdiff(gdscOnlyLines, strDistTab$MATCH_1)

#--------------------------------------------------------------------------------------------------
# ADD ROWS FOR REMAINING (UNMATCHED) GDSC-ONLY LINES.
#--------------------------------------------------------------------------------------------------

tmp <- data.frame(nci60=NA, cgp=NA, gdsc=gdscOnlyLines, ccle=NA, stringsAsFactors = FALSE)
stopifnot(identical(colnames(tmp), colnames(newCellMatchTab)))

newCellMatchTab <- rbind(newCellMatchTab, tmp)


#--------------------------------------------------------------------------------------------------
# SAVE UPDATED CELL LINE MATCH TABLE.
#--------------------------------------------------------------------------------------------------

cellLineMatchTab <- newCellMatchTab


stopifnot(all(!duplicated(na.exclude(cellLineMatchTab$nci60))))
stopifnot(all(!duplicated(na.exclude(cellLineMatchTab$cgp))))
stopifnot(all(!duplicated(na.exclude(cellLineMatchTab$gdsc))))
stopifnot(all(!duplicated(na.exclude(cellLineMatchTab$ccle))))

stopifnot(identical(sort(na.exclude(cellLineMatchTab$nci60)), sort(colnames(nci60Exp))))
stopifnot(identical(sort(na.exclude(cellLineMatchTab$cgp)), sort(colnames(cgpExp))))
stopifnot(identical(sort(na.exclude(cellLineMatchTab$gdsc)), sort(colnames(gdscExp))))
stopifnot(identical(sort(na.exclude(cellLineMatchTab$ccle)), sort(colnames(ccleExp))))

# TO DO: for additional testing, can write a function that computes the maximum pairwise
# string distance among cell lines in a cell line match table row.  Check rows with larger
# (distance) scores directly.


save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
