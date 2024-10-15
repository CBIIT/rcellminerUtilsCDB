#--------------------------------------------------------------------------------------------------
# add 8 cell lines to nob
#   
#--------------------------------------------------------------------------------------------------

# library(rcellminerUtilsCDB)
 
currenttable=rcellminerUtilsCDB::cellLineMatchTab
dim(currenttable) # 2100 38

## ---------------------------------
newcells = c("BEN","SAM","JEN","KT", "MN1" ,"GAR")
existcells = c("CH157", "IOMM")
# matching ccle
cclecells = c("CH-157MN", "IOMM-Lee")

idx  = match(cclecells , currenttable$ccle)
currenttable$nob[idx] = existcells
 
## add new ones 

currenttable[2101:2106,] = NA
currenttable[2101:2106,"nob"] = newcells

# saving

dim(currenttable) # 2106 38
cellLineMatchTab <- currenttable

save(cellLineMatchTab, file = "data/cellLineMatchTab.RData")

## END
## stop here ----------------------





















