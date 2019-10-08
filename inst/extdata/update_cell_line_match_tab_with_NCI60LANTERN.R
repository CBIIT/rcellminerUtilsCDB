#--------------------------------------------------------------------------------------------------
# UPDATE cell line matching table with NCI60 and Lantern
# ------------------------------------------------------------

library(rcellminerUtilsCDB)
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 1825 16

#currenttable = data.frame(apply(currenttable,2,as.character),stringsAsFactors = F)

currenttable$lantnci = currenttable$nci60
dim(currenttable) # 1825 17



##-----------
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

#--------------------------------------------------------------------------------------------------
