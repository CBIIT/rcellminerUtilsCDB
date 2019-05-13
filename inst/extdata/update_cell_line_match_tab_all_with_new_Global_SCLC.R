f#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE
# 
#--------------------------------------------------------------------------------------------------
library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1821 11

# rownames(currenttable)=1:1821
cellsm=read.delim("./inst/extdata/cellmatchs_new_genSclc_curated.txt", stringsAsFactors = F)
dim(cellsm) # 1820 12


cellLineMatchTab <- cellsm
save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
