#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE
# 48 ccle cell lines  =  28 new CCLE cell lines + 20 (exit in other sources)
#--------------------------------------------------------------------------------------------------
library(rcellminerUtils)
dim(rcellminerUtils::cellLineMatchTab) # 1744 - 9
# save current match
write.table(rcellminerUtils::cellLineMatchTab,"./inst/extdata/cellLineMatchTab.06202018.txt",sep="\t",row.names = F)
#

annotnew=read.delim("inst/extdata/cellLineMatchTab_new_ccle.txt")
dim(annotnew) # 1772 - 9 ## missing almanac

View(annotnew)


cellLineMatchTab <- annotnew
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
