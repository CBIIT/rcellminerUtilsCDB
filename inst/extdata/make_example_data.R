#--------------------------------------------------------------------------------------------------
# EXTRACT AND SAVE CCLE LUNG CANCER CELL LINE EXPRESSION DATA.
#--------------------------------------------------------------------------------------------------
library(rcellminer)
ccleEnv <- new.env()
data("molData", package="ccleData", envir=ccleEnv)
data("drugData", package="ccleData", envir=ccleEnv)

ccleAnnot <- getSampleData(ccleEnv$molData)
ccleExpData <- getAllFeatureData(ccleEnv$molData)[["exp"]]

ccleLungAnnot <- ccleAnnot[(ccleAnnot$OncoTree1 == "Lung"), ]
rownames(ccleLungAnnot) <- ccleLungAnnot$Name

ccleLungExpData <- ccleExpData[, ccleLungAnnot$Name]

stopifnot(identical(rownames(ccleLungAnnot), colnames(ccleLungExpData)))

save(list = c("ccleLungAnnot", "ccleLungExpData"), file = "./inst/data-raw/ccleLungData.RData")

#--------------------------------------------------------------------------------------------------
