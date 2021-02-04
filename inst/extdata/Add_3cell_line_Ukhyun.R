#--------------------------------------------------------------------------------------------------
#Adding 3 new cell lines for Ukhyun: CCRF-CEM and MOLT-4 exist in GDSC
#                                    HAP-1 new cell line
#--------------------------------------------------------------------------------------------------
# There are 13 cell lines
#
# ---------------------------------------------------------

library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2048 - 24

i = match(c("CCRF-CEM","MOLT-4"), currenttable$gdscDec15)

currenttable$ukhyun[i]= c("CCRF-CEM","MOLT-4")

currenttable[2049,] = NA
currenttable$ukhyun[2049] = "HAP-1"

length(which(!is.na(currenttable$ukhyun))) # 16
## END ======================

dim(currenttable) # 2049 - 24
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END

















