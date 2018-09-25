#--------------------------------------------------------------------------------------------------
# LOAD CELL LINE MATCH TABLE TOGETHER WITH NCI-60, CGP, AND CCLE DATA PACKAGE OBJECTS.
#--------------------------------------------------------------------------------------------------
require(rcellminer)

svCellLineMatch <- read.table(file="./inst/data-raw/sv_cell_line_matches.txt",
                              header=TRUE, sep="\t", stringsAsFactors=FALSE,
                              check.names = FALSE, comment.char="", quote="", na.strings="")

nci60Env <- new.env()
data("molData", package="rcellminerData", verbose=TRUE, envir=nci60Env)
data("drugData", package="rcellminerData", verbose=TRUE, envir=nci60Env)
nci60SampleData <- getSampleData(nci60Env$molData)

ccleEnv <- new.env()
data("molData", package="ccleData", verbose=TRUE, envir=ccleEnv)
data("drugData", package="ccleData", verbose=TRUE, envir=ccleEnv)
ccleSampleData <- getSampleData(ccleEnv$molData)

cgpEnv <- new.env()
data("molData", package="cgpData", verbose=TRUE, envir=cgpEnv)
data("drugData", package="cgpData", verbose=TRUE, envir=cgpEnv)
cgpSampleData <- getSampleData(cgpEnv$molData)

#--------------------------------------------------------------------------------------------------
# RESTRICT LARGER MATCH TABLE TO ENTRIES ASSOCIATED WITH DATA PACKAGE NCI-60, CGP, CCLE LINES.
#--------------------------------------------------------------------------------------------------

for (i in seq(nrow(svCellLineMatch))){
  if ((!is.na(svCellLineMatch$nci60[i])) && (!(svCellLineMatch$nci60[i] %in% nci60SampleData$Name))){
    svCellLineMatch[i, "nci60"] <- NA
  }

  if ((!is.na(svCellLineMatch$ccle[i])) && (!(svCellLineMatch$ccle[i] %in% ccleSampleData$Name))){
    svCellLineMatch[i, "ccle"] <- NA
  }

  if ((!is.na(svCellLineMatch$cgp[i])) && (!(svCellLineMatch$cgp[i] %in% cgpSampleData$Name))){
    svCellLineMatch[i, "cgp"] <- NA
  }
}

isAllNa <- apply(svCellLineMatch, MARGIN = 1, FUN = function(x) all(is.na(x)))

svCellLineMatch <- svCellLineMatch[!isAllNa, ]

stopifnot(all(na.exclude(svCellLineMatch$cgp) %in% cgpSampleData$Name))
stopifnot(all(na.exclude(svCellLineMatch$ccle) %in% ccleSampleData$Name))
stopifnot(all(na.exclude(svCellLineMatch$nci60) %in% nci60SampleData$Name))

#--------------------------------------------------------------------------------------------------
# CONSTRUCT PACKAGE CELL LINE MATCH TABLE WITH: (1) NCI-60/CGP/CCLE MATCHES, (2) CGP/CCLE MATCHES.
#--------------------------------------------------------------------------------------------------

nci60Match <- svCellLineMatch[which(svCellLineMatch$nci60 %in% nci60SampleData$Name), ]
missingLine <- setdiff(nci60SampleData$Name, svCellLineMatch$nci60)
stopifnot(length(missingLine) == 1)
nci60Match <- rbind(nci60Match, c(NA, NA, missingLine))
stopifnot(identical(sort(nci60Match$nci60), sort(nci60SampleData$Name)))
rownames(nci60Match) <- nci60Match$nci60
nci60Match <- nci60Match[nci60SampleData$Name, ]

nonNci60CcleCgpMatch <- svCellLineMatch[is.na(svCellLineMatch$nci60), ]
isCcleCgpMatch <- (!is.na(nonNci60CcleCgpMatch$ccle)) & (!(is.na(nonNci60CcleCgpMatch$cgp)))
nonNci60CcleCgpMatch <- nonNci60CcleCgpMatch[isCcleCgpMatch, ]

cellLineMatchTab <- rbind(nci60Match, nonNci60CcleCgpMatch)

#--------------------------------------------------------------------------------------------------
# ADD TO PACKAGE CELL LINE MATCH TABLE: ENTRIES FOR REMAINING (UNMATCHED) CCLE AND CGP LINES.
#--------------------------------------------------------------------------------------------------

unmatchedCcle <- setdiff(ccleSampleData$Name, na.exclude(cellLineMatchTab$ccle))
tmp <- data.frame(cgp = rep(NA, length(unmatchedCcle)), ccle = unmatchedCcle,
                  nci60 = rep(NA, length(unmatchedCcle)),
                  stringsAsFactors = FALSE)
stopifnot(identical(colnames(tmp), colnames(cellLineMatchTab)))
cellLineMatchTab <- rbind(cellLineMatchTab, tmp)

unmatchedCgp <- setdiff(cgpSampleData$Name, na.exclude(cellLineMatchTab$cgp))
tmp <- data.frame(cgp = unmatchedCgp, ccle = rep(NA, length(unmatchedCgp)),
                  nci60 = rep(NA, length(unmatchedCgp)),
                  stringsAsFactors = FALSE)
stopifnot(identical(colnames(tmp), colnames(cellLineMatchTab)))
cellLineMatchTab <- rbind(cellLineMatchTab, tmp)

cellLineMatchTab <- cellLineMatchTab[, c("nci60", "cgp", "ccle")]
rownames(cellLineMatchTab) <- as.character(seq(nrow(cellLineMatchTab)))

stopifnot(identical(sort(na.exclude(cellLineMatchTab$cgp)), sort(cgpSampleData$Name)))
stopifnot(identical(sort(na.exclude(cellLineMatchTab$ccle)), sort(ccleSampleData$Name)))
stopifnot(identical(sort(na.exclude(cellLineMatchTab$nci60)), sort(nci60SampleData$Name)))

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
