#--------------------------------------------------------------------------------------------------
# UPDATE ORIGINAL TABLE with CSHL  (Histone data  cell lines)
# 
#--------------------------------------------------------------------------------------------------
# There are 13 cell lines 
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1822 15

#currenttable = data.frame(apply(currenttable,2,as.character),stringsAsFactors = F)

currenttable$lantern = currenttable$nci60
dim(currenttable) # 1822 16



##-----------
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
