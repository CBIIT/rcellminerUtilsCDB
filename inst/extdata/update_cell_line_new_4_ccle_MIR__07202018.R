#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE
# 4 ccle cell lines  =  1 new CCLE cell lines + 3 (exist in other sources)
#--------------------------------------------------------------------------------------------------
library(rcellminerUtils)
dim(rcellminerUtils::cellLineMatchTab) # 1772 - 9
# save current match
write.table(rcellminerUtils::cellLineMatchTab,"./inst/extdata/cellLineMatchTab.07202018.txt",sep="\t",row.names = F)
#

annotnew=read.delim("inst/extdata/cellLineMatchTab_new_ccle_microrna.txt")
dim(annotnew) # 1772 - 9 ## missing almanac

View(annotnew)


cellLineMatchTab <- annotnew
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
