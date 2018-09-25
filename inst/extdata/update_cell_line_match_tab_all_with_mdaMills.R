#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE
# we will update all table adding the Gordo Mills cell lines and moving fro 1520 row to
# 1744
#--------------------------------------------------------------------------------------------------
library(rcellminerUtils)
dim(rcellminerUtils::cellLineMatchTab) # 1520 - 8

annotnew=read.delim("inst/extdata/cellLineMatchFile_newALL_mdaMills.txt")
dim(annotnew) # 1744 - 8 ## missing almanac


annotnew$almanac <-  annotnew$nci60



cellLineMatchTab <- annotnew
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
